{pkgs, ...}: let
  username = "ominit"; # TODO automatically figure out username
in {
  home-manager.users."${username}".home.file.".config/nushell/" = {
    source = ./config/.;
    recursive = true;
  };

  users.users."${username}".packages = with pkgs; [nushell fish carapace starship];
}
