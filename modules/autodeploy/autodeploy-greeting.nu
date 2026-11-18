if $nu.is-interactive {
  do {
    let state = try { open /var/lib/autodeploy/state.json } catch { {} }
    let since = try { $state.since | into datetime | date humanize } catch { "" }
    let sha = $state.sha? | default "" | str substring 0..6

    let status = match $state.status? {
      "paused" => $"paused, ($state.reason)"
      "waiting" => $"waiting since ($since) on ($state.reason)"
      "checks-failed" => $"checks failed on ($sha): ($state.reason)"
      "build-failed" => $"couldn't build ($sha): ($state.reason)"
      "failed" => $"deploying ($sha) failed at ($state.reason)"
      _ => null
    }

    let resolve = {|path| try { $path | path expand } catch { null } }
    let staged = (do $resolve /nix/var/nix/profiles/system) != (do $resolve /run/current-system)
    let changed = [kernel initrd kernel-modules] | where {|part|
      (do $resolve $"/run/booted-system/($part)") != (do $resolve $"/run/current-system/($part)")
    }

    let notes = [
      $status
      (if $staged { "a new generation is staged, reboot to apply it" })
      (if not $staged and ($changed | is-not-empty) { $"reboot pending, ($changed | str join ', ') changed" })
    ] | compact

    for note in $notes {
      print $"(ansi yellow)autodeploy(ansi reset) ($note)"
    }
  }
}
