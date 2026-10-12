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
              nixpkgs.config.allowUnfree = true;
            }
            ({config, ...}: {
              _module.args.multiverse = inputs.multiverse.lib.mkMultiverse {
                inherit system;
                inherit (config.nixpkgs) config;
              };
            })
            ./../modules
          ]
          ++ modules;
      });
in {
  inherit mkNixosSystem;
}
