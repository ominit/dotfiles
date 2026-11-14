{
  self,
  lib,
  ...
}: {
  perSystem = {system, ...}: {
    checks = let
      hosts = lib.filterAttrs (_: config: config.pkgs.system == system) self.nixosConfigurations;
      nixosConfigurations = lib.mapAttrs' (name: config: lib.nameValuePair "nixos-${name}" config.config.system.build.toplevel) hosts;
      nixbotTests = lib.mapAttrs' (name: config: lib.nameValuePair "nixbot-tests-${name}" config.config.services.nixbot.packages.nixbot.passthru.tests.pytest) (lib.filterAttrs (_: config: config.config.services.nixbot.enable or false) hosts);
    in
      nixosConfigurations // nixbotTests;
  };
}
