{pkgs, ...}: let
  username = "ominit";
in {
  programs.hyprland = {
    enable = true;
    # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  home-manager.users."${username}".home.file.".config/hypr/" = {
    source = ./config/.;
    recursive = true;
  };

  users.users."${username}".packages = with pkgs; [
    swww
    hyprlock
    hypridle
    rofi-wayland
    hyprpolkitagent
    hyprpicker
    clipse
    wl-clipboard
    waypaper
    brightnessctl
    playerctl
    pamixer
    wlogout
  ];
}
