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

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
      configPackages = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      config = {
        common = {
          default = ["wlr" "gtk"];
          "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
          "org.freedesktop.impl.portal.Screenshot" = ["wlr"];
          "org.freedesktop.impl.portal.Screencast" = ["wlr"];
        };
      };
    };

    programs.niri = {
      enable = true;
      package = config.modules.programs."${pkg}".package;
    };

    modules.programs = {
      # hyprlock.enable = true;
      # hypridle.enable = true;
      # niriswitcher.enable = true;
    };
  };

  options.modules.programs."${pkg}" = {
    enable = mkEnableOption "enable niri";
    package = mkPackageOption pkgs "niri" {};
  };
}
