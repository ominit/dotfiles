{
  self,
  config,
  lib,
  inputs,
  ...
}: {
  flake.hydraJobs = let
    allJobs =
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
    allJobs
    // {
      allJobs = inputs.nixpkgs.legacyPackages.${builtins.head config.systems}.releaseTools.aggregate {
        name = "allJobs";
        constituents = lib.collect lib.isDerivation allJobs;
      };
    };
}
