{
  inputs,
  pkgs,
  ...
}: {
  # imports = [inputs.hyprpanel.homeManagerModules.hyprpanel];

  nixpkgs.overlays = [
    inputs.hyprpanel.overlay
  ];

  users.users."ominit".packages = with pkgs; [hyprpanel];

  # home-manager.users."ominit".programs.hyprpanel = {
  #   enable = true;
  #   systemd.enable = true;
  #   hyprland.enable = true;
  #   settings = {
  #     bar.launcher.autoDetectIcon = true;
  #   };
  # };
}
