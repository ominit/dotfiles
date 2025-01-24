{pkgs, ...}: {
  home-manager.users."ominit".home.file.".config/rofi/" = {
    source = ./config/.;
    recursive = true;
  };

  users.users."ominit".packages = with pkgs; [
    rofi-wayland
  ];
}
