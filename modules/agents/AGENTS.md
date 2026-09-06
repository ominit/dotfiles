# Agent instructions

If a required program is unavailable, use the repository's `nix develop` environment when it provides the tool. Otherwise, run it temporarily with `nix shell nixpkgs#<package> --command <command>`.

The user uses `jj` as their primary vcs, so use jj when possible and git as a secondary.
