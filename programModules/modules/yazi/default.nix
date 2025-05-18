{
  pkgs,
  inputs,
  ...
}: let
  username = "ominit"; # TODO automatically figure out username
in {
  home-manager.users."${username}".home.file.".config/yazi/" = {
    source = ./config/.;
    recursive = true;
  };

  # users.users."${username}".packages = [inputs.yazi.packages.${pkgs.system}.default];
  users.users."${username}".packages = [pkgs.yazi];
}
