{
  pkgs,
  inputs,
  ...
}: {
  home.file.".config/hypr/" = {
    source = ./.;
    recursive = true;
  };

  home.packages = with pkgs; [
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
    # hyprpanel
  ];
}
