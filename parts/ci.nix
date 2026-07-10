{
  self,
  lib,
  ...
}: {
  perSystem = {system, ...}: {
    checks = let
      nixosConfigurations = lib.mapAttrs' (name: config: lib.nameValuePair "nixos-${name}" config.config.system.build.toplevel) ((lib.filterAttrs (_: config: config.pkgs.system == system)) self.nixosConfigurations);
    in
      nixosConfigurations;
  };
}
