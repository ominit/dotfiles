def main [state_path: string] {
  let state = open $state_path
  let marker = $env.XDG_STATE_HOME? | default $"($env.HOME)/.local/state" | path join autodeploy-notified
  let key = $"($state.status) ($state.sha?)"
  if (try { open --raw $marker | str trim } catch { "" }) == $key {
    return
  }

  let sha = $state.sha? | default "" | str substring 0..6
  let staged = ("/nix/var/nix/profiles/system" | path expand) != ("/run/current-system" | path expand)
  let message = match $state.status {
    "deployed" if $staged => $"Staged ($sha). Reboot to apply it."
    "build-failed" => $"Couldn't build ($sha): ($state.reason)"
    "failed" => $"Deploying ($sha) failed at ($state.reason)"
    _ => null
  }

  if $message != null {
    ^notify-send --app-name autodeploy autodeploy $message
  }
  mkdir ($marker | path dirname)
  $key | save --force $marker
}
