{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkPackageOption;

  pkg = "hyprlock";
in {
  config = mkIf config.modules.programs."${pkg}".enable {
    hjem.users."ominit" = {
      files.".config/hypr/hyprlock.conf" = {
        source = ./config/hyprlock.conf;
        clobber = true;
      };

      files.".config/hypr/hyprlock/bg.jpg" = {
        source = ./config/bg.jpg;
        clobber = true;
      };

      packages = [
        config.modules.programs."${pkg}".package
      ];
    };
  };

  options.modules.programs."${pkg}" = {
    enable = mkEnableOption "enable hyprlock";
    package = mkPackageOption pkgs "hyprlock" {};
  };
}
