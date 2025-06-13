{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption mkPackageOption;
in {
  config = mkIf config.modules.programs.bat.enable {
    hjem.users."ominit" = {
      files.".config/bat/" = {
        source = ./config;
        clobber = true;
      };

      packages = with pkgs; [
        config.modules.programs.bat.package
      ];
    };

    # need to run `bat cache --build` to apply config
    system.userActivationScripts.bat-cache-build = {
      text = ''
        ${config.modules.programs.bat.package}/bin/bat cache --build
      '';
    };
  };

  options.modules.programs.bat = {
    enable = mkEnableOption "enable bat";
    package = mkPackageOption pkgs "bat" {};
  };
}
