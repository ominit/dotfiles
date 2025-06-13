{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption mkPackageOption;

  pkg = "bat";
in {
  config = mkIf config.modules.programs."${pkg}".enable {
    hjem.users."ominit" = {
      files.".config/bat/" = {
        source = ./config;
        clobber = true;
      };

      packages = with pkgs; [
        config.modules.programs."${pkg}".package
      ];
    };

    # need to run `bat cache --build` to apply config
    system.userActivationScripts.bat-cache-build = {
      text = ''
        ${config.modules.programs."${pkg}".package}/bin/bat cache --build
      '';
    };
  };

  options.modules.programs."${pkg}" = {
    enable = mkEnableOption "enable bat";
    package = mkPackageOption pkgs "bat" {};
  };
}
