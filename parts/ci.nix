{
  self,
  config,
  lib,
  inputs,
  ...
}: {
  flake.hydraJobs = let
    requiredJobs =
      {
        nixosConfigurations =
          builtins.mapAttrs
          (_name: cfg: cfg.config.system.build.toplevel)
          (self.nixosConfigurations);
      }
      // (
        lib.genAttrs config.systems (system: {
          checks = self.checks.${system};
        })
      );
  in
    requiredJobs
    // {
      required = inputs.nixpkgs.legacyPackages.${builtins.head config.systems}.releaseTools.aggregate {
        name = "required";
        constituents = lib.collect lib.isDerivation requiredJobs;
      };
    };
}
