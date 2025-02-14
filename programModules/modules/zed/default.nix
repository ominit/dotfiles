{
  pkgs,
  inputs,
  ...
}: {
  # home-manager.users."ominit".home.file.".config/zed/" = {
  #   source = ./config/.;
  #   recursive = true;
  # };

  users.users."ominit".packages = [pkgs.zed-editor];
}
