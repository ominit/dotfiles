{
  pkgs,
  inputs,
  ...
}: let
  username = "ominit"; # TODO automatically figure out username
in {
  home-manager.users."${username}".home.file.".config/helix/" = {
    source = ./config/.;
    recursive = true;
  };

  users.users."${username}".packages = with pkgs; [
    inputs.helix.packages."${pkgs.system}".helix
    nil
    nixd
    alejandra
    taplo
    lua-language-server
  ];
}
