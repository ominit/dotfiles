{
  config,
  lib,
  helperLib,
  ...
}: let
  cfg = config.myPrograms;
  modules = helperLib.extendModules (name: {
    extraOptions = {
      myPrograms.${name}.enable = lib.mkEnableOption "enable ${name}";
    };

    configExtension = config: (lib.mkIf cfg.${name}.enable config);
  }) (helperLib.filesIn ./modules);
in {
  imports = [] ++ modules;
}
