{
  pkgs,
  inputs,
  ...
}: let
  username = "ominit"; # TODO automatically figure out username
in {
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  home-manager.users."${username}".home.file.".config/hypr/" = {
    source = ./config/.;
    recursive = true;
  };

  users.users."${username}".packages = with pkgs; [
    inputs.hyprland.packages.${pkgs.system}.hyprland
    swww
    hyprlock
    hypridle
    rofi-wayland
    # mako
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
