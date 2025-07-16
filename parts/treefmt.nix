{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];
  perSystem = {config, ...}: {
    treefmt = {
      # `nix fmt` and creates formatting check
      projectRootFile = "flake.nix";

      programs.alejandra.enable = true;
    };
  };
}
