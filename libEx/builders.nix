{
  inputs,
  lib,
  ...
}: let
  inherit (inputs) self;

  mkNixosSystem = {
    withSystem,
    system,
  } @ args:
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
              networking.hostName = args.hostname;
              nixpkgs.hostPlatform = args.system;
              nix.settings.experimental-features = ["nix-command" "flakes"];
              nix.settings.substituters = [
                "https://cache.garnix.io"
                "https://hyprland.cachix.org"
              ];
              nix.settings.trusted-public-keys = [
                "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
                "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
              ];
              nixpkgs.config.allowUnfree = true;
            }
            ./../modules
          ]
          ++ args.modules;
      });
in {
  inherit mkNixosSystem;
}
