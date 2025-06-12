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
        };

        modules =
          args.modules
          ++ [
            {
              networking.hostName = args.hostname;
              nixpkgs = {
                hostPlatform = args.system;
              };
              nix.settings.experimental-features = ["nix-command" "flakes"];
            }
            ./../modules
            inputs.hjem.nixosModules.default
          ];
      });
in {
  inherit mkNixosSystem;
}
