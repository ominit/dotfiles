{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkPackageOption;

  pkg = "niri";
in {
  config = mkIf config.modules.programs."${pkg}".enable {
    hjem.users."ominit" = {
      files.".config/niri" = {
        source = ./config;
        clobber = true;
      };

      packages = with pkgs; [
        xwayland-satellite
      ];
    };

    programs.niri = {
      enable = true;
      package = config.modules.programs."${pkg}".package;
    };

    modules.programs = {
      hyprlock.enable = true;
      hypridle.enable = true;
    };
  };

  options.modules.programs."${pkg}" = {
    enable = mkEnableOption "enable niri";
    package = mkPackageOption pkgs "niri_git" {};
  };
}
