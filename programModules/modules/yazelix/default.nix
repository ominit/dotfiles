{...}: let
  username = "ominit"; # TODO automatically figure out username
in {
  home-manager.users."${username}".home.file.".config/yazelix/" = {
    source = ./config/.;
    recursive = true;
  };
}
