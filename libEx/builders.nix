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
                "https://harmonia.42nd.net/"
                "https://nix-community.cachix.org"
                "https://attic.xuyh0120.win/lantian"
                "https://cache.numtide.com"
              ];
              nix.settings.trusted-public-keys = [
                # "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
                # "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
                "harmonia.42nd.net:JD9qs95wYpbknQHbJRBHs/mW8kIHbWeh5tQhVu3+B3A="
                "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
                "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
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
