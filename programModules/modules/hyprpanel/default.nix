{inputs, ...}: {
  home-manager.users."ominit" = {
    imports = [inputs.hyprpanel.homeManagerModules.hyprpanel];
    programs.hyprpanel = {
      enable = true;
      overwrite.enable = true;
      overlay.enable = true;
      hyprland.enable = true;
      settings = {
        bar.autoHide = "fullscreen";
        bar.clock.format = "%I:%M %p";
        bar.clock.showIcon = false;
        bar.launcher.autoDetectIcon = true;
        bar.media.show_active_only = true;
        bar.workspaces.show_numbered = true;
        theme.bar.floating = true;
        theme.bar.layer = "overlay";
        theme.bar.transparent = true;
      };
    };
  };
}
