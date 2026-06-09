{
  inputs,
  lib,
  ...
}: let
  inherit (inputs) self;

  mkNixosSystem = {
    withSystem,
    hostname,
    system,
    modules,
  }:
    withSystem system ({
      inputs',
      self',
      ...
    }:
      lib.nixosSystem {
        specialArgs = {
          inherit lib;
          inherit inputs inputs' self self';
          inherit system;
        };

        modules =
          [
            {
              networking.hostName = hostname;
              nixpkgs.hostPlatform = system;
              nix.settings.experimental-features = ["nix-command" "flakes" "ca-derivations" "dynamic-derivations" "recursive-nix"];
              nix.settings.substituters = [
                # "https://cache.garnix.io"
                # "https://hyprland.cachix.org"
                "https://circus.42nd.net/nix-cache/"
              ];
              nix.settings.trusted-public-keys = [
                # "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
                # "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
                "circus.42nd.net:JD9qs95wYpbknQHbJRBHs/mW8kIHbWeh5tQhVu3+B3A="
              ];
              nixpkgs.config.allowUnfree = true;
            }
            ./../modules
          ]
          ++ modules;
      });
in {
  inherit mkNixosSystem;
}
