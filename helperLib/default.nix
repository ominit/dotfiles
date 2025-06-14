{inputs}: let
  helperLib = (import ./default.nix) {inherit inputs;};
  vars = import ./../vars.nix;
  outputs = inputs.self.outputs;
in rec {
  pkgsFor = sys: inputs.nixpkgs.legacyPackages.${sys};

  mkSystem = config:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs outputs helperLib vars;
      };
      modules = [
        config
      ];
    };

  mkHome = sys: config:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = pkgsFor sys;
      specialArgs = {
        inherit inputs outputs helperLib vars;
      };
      modules = [
        config
      ];
    };

  filesIn = dir:
    (map (fname: dir + "/${fname}"))
    (builtins.attrNames (builtins.readDir dir));

  dirsIn = dir:
    inputs.nixpkgs.lib.filterAttrs (name: value: value == "directory")
    (builtins.readDir dir);

  fileNameOf = path: (builtins.head (builtins.split "\\." (baseNameOf path)));

  extendModule = {path, ...} @ args: {pkgs, ...} @ margs: let
    eval =
      if (builtins.isString path) || (builtins.isPath path)
      then import path margs
      else path margs;

    evalNoImports = builtins.removeAttrs eval ["imports" "options"];

    extra =
      if (builtins.hasAttr "extraOptions" args) || (builtins.hasAttr "extraConfig" args)
      then [
        ({...}: {
          options = args.extraOptions or {};
          config = args.extraConfig or {};
        })
      ]
      else [];
  in {
    imports = (eval.imports or []) ++ extra;

    options =
      if builtins.hasAttr "optionsExtension" args
      then (args.optionsExtension (eval.options or {}))
      else (eval.options or {});

    config =
      if builtins.hasAttr "configExtension" args
      then (args.configExtension (eval.config or evalNoImports))
      else (eval.config or evalNoImports);
  };

  extendModules = extension: modules:
    map
    (f: let
      name = fileNameOf f;
    in (extendModule ((extension name) // {path = f;})))
    modules;
}
