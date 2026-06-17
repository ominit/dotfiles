{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkPackageOption;

  pkg = "bat";
in {
  config = mkIf config.modules.programs."${pkg}".enable {
    hjem.users."ominit" = {
      files = {
        ".config/bat/config" = {
          source = ./config/config;
          clobber = true;
        };

        ".config/bat/themes/Embark.tmTheme" = {
          source = ./config/themes/Embark.tmTheme;
          clobber = true;
        };
      };

      packages = with pkgs; [
        config.modules.programs."${pkg}".package
      ];
    };

    # need to run `bat cache --build` to apply config
    system.userActivationScripts.batCacheBuild = {
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
