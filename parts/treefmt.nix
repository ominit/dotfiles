{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];
  perSystem = {...}: {
    treefmt = {
      # `nix fmt` and creates formatting check
      projectRootFile = "flake.nix";

      programs.alejandra.enable = true;
      programs.deadnix.enable = true;
      programs.jsonfmt.enable = true;
      programs.taplo.enable = true;
      programs.yamlfmt.enable = true;
    };
  };
}
