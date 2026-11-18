const repository = "ominit/dotfiles"
const ref = "refs/heads/main"
const required_checks = ["nixbot/nix-eval" "nixbot/nix-build"]
const current = "/run/current-system"
const profile = "/nix/var/nix/profiles/system"

def save-state [path: string, prev: record, next: record] {
  let since = if ($prev.status? == $next.status and $prev.sha? == $next.sha?) { $prev.since? }
  let state = {deployed: $prev.deployed?, failed: $prev.failed?}
    | merge $next
    | merge {since: ($since | default (date now | format date "%+"))}
  $state | to json | save --force $"($path).tmp"
  mv --force $"($path).tmp" $path
  print $"($state.status) ($state.sha? | default '') ($state.reason? | default '')"
}

def sync [repo: string] {
  if not ($repo | path exists) {
    ^git init --quiet --bare $repo
  }
  ^git -C $repo fetch --quiet $"https://github.com/($repository).git" $"+($ref):($ref)"
  ^git -C $repo rev-parse $ref | str trim
}

def is-ancestor [repo: string, rev: string] {
  (do { ^git -C $repo merge-base --is-ancestor $rev $ref } | complete).exit_code == 0
}

def nar-hash [repo: string, sha: string] {
  let dir = mktemp -d
  ^git -C $repo archive $sha | ^tar -x -C $dir
  let hash = ^nix hash path $dir | str trim
  rm -r -f $dir
  $hash
}

def landed [repo: string, source: record] {
  ^git -C $repo rev-list $"--since=($source.lastModified - 86400)" $ref
    | lines
    | any {|sha| (nar-hash $repo $sha) == $source.narHash }
}

def pause-reason [repo: string] {
  for system in [[path label]; [$current running] [$profile "staged for boot is"]] {
    let file = $"($system.path)/autodeploy-source.json"
    if not ($file | path exists) {
      continue
    }
    let source = open $file
    if ($source.rev != null and (is-ancestor $repo $source.rev)) or (landed $repo $source) {
      continue
    }
    let rev = if $source.rev != null {
      $source.rev | str substring 0..11
    } else if $source.dirtyRev != null {
      $"($source.dirtyRev | str substring 0..11)-dirty"
    } else {
      "a build from outside git"
    }
    return $"($system.label) ($rev), which isn't on main"
  }
  null
}

def check-runs [sha: string] {
  let runs = http get --headers {Accept: "application/vnd.github+json"} $"https://api.github.com/repos/($repository)/commits/($sha)/check-runs?per_page=100" | get check_runs
  let names = $runs | each { get name }
  {
    failed: ($runs | where status == completed and conclusion not-in [success neutral skipped] | each { get name })
    pending: (($runs | where status != completed | each { get name }) ++ ($required_checks | where {|name| $name not-in $names }))
  }
}

def build [hostname: string, sha: string] {
  let result = do {
    ^nix build --no-link --print-out-paths $"github:($repository)/($sha)#nixosConfigurations.($hostname).config.system.build.toplevel"
  } | complete
  print --stderr $result.stderr
  if $result.exit_code == 0 {
    {path: ($result.stdout | str trim)}
  } else {
    {error: ($result.stderr | str trim | lines | last | default "nix build failed")}
  }
}

def affected-units [path: string] {
  let result = do { ^$"($path)/bin/switch-to-configuration" dry-activate } | complete
  if $result.exit_code != 0 {
    return null
  }
  $result.stderr
    | lines
    | parse --regex '^would (?:stop|restart) the following units: (?<units>.*)$'
    | each {|row| $row.units | split row ", " }
    | flatten
}

def relevant-gates [gates: list, units: any] {
  if $units == null {
    return $gates
  }
  $gates | where {|gate| ($units | is-not-empty) and (($gate.units | is-empty) or ($gate.units | any {|unit| $unit in $units })) }
}

def failing [scripts: list] {
  $scripts | each {|script|
    let result = do { ^timeout 60 $script.command } | complete
    if $result.exit_code != 0 {
      {name: $script.name, output: ($"($result.stdout)\n($result.stderr)" | str trim | lines | str join ", ")}
    }
  }
}

def describe [failures: list] {
  $failures | each {|failure|
    if $failure.output == "" { $failure.name } else { $"($failure.name) \(($failure.output))" }
  } | str join ", "
}

def wait-healthy [checks: list] {
  let deadline = (date now) + 2min
  loop {
    let failures = failing $checks
    if ($failures | is-empty) or (date now) > $deadline {
      return $failures
    }
    sleep 5sec
  }
}

def activate [path: string, action: string] {
  try { ^$"($path)/bin/switch-to-configuration" $action; true } catch { false }
}

def main [settings: path] {
  let config = open $settings
  let state_path = $"($config.stateDir)/state.json"
  let repo = $"($config.stateDir)/repo.git"
  let state = try { open $state_path } catch { {} }

  let head = try { sync $repo } catch { null }
  if $head == null {
    save-state $state_path $state {status: offline, sha: $state.sha?, reason: $"couldn't fetch ($repository)"}
    return
  }

  let paused = pause-reason $repo
  if $paused != null {
    save-state $state_path $state {status: paused, sha: $head, reason: $paused}
    return
  }

  if $state.deployed?.sha? == $head {
    save-state $state_path $state {status: deployed, sha: $head}
    return
  }

  if $state.failed?.sha? == $head {
    save-state $state_path $state {status: failed, sha: $head, reason: $state.failed.reason}
    return
  }

  let checks = try { check-runs $head } catch { null }
  if $checks == null {
    save-state $state_path $state {status: offline, sha: $head, reason: "couldn't read checks"}
    return
  }
  if ($checks.failed | is-not-empty) {
    save-state $state_path $state {status: checks-failed, sha: $head, reason: ($checks.failed | str join ", ")}
    return
  }
  if ($checks.pending | is-not-empty) {
    save-state $state_path $state {status: checks-pending, sha: $head, reason: ($checks.pending | str join ", ")}
    return
  }

  let built = build $config.hostname $head
  if $built.error? != null {
    save-state $state_path $state {status: build-failed, sha: $head, reason: $built.error}
    return
  }
  let path = $built.path

  if $config.mode == "switch" and ($current | path expand) != $path {
    let busy = failing (relevant-gates $config.gates (affected-units $path))
    if ($busy | is-not-empty) {
      save-state $state_path $state {status: waiting, sha: $head, reason: (describe $busy)}
      return
    }

    activate $path test
    let unhealthy = wait-healthy $config.healthChecks
    if ($unhealthy | is-not-empty) {
      let reason = $"health checks: (describe $unhealthy)"
      save-state $state_path $state {status: failed, sha: $head, reason: $reason, failed: {sha: $head, reason: $reason}}
      return
    }
  }

  if ($profile | path expand) != $path {
    ^nix-env --profile $profile --set $path
    if not (activate $path boot) {
      let reason = "switch-to-configuration boot"
      save-state $state_path $state {status: failed, sha: $head, reason: $reason, failed: {sha: $head, reason: $reason}}
      return
    }
  }

  save-state $state_path $state {status: deployed, sha: $head, deployed: {sha: $head}}
}
