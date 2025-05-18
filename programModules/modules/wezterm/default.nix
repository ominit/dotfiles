{
  pkgs,
  inputs,
  ...
}: let
  username = "ominit"; # TODO automatically figure out username
in {
  home-manager.users."${username}".home.file.".config/wezterm/" = {
    source = ./config/.;
    recursive = true;
  };

  # users.users."${username}".packages = [inputs.wezterm.packages.${pkgs.system}.default];
  users.users."${username}".packages = [pkgs.wezterm];
}
