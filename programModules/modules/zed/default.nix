{
  pkgs,
  inputs,
  ...
}: {
  # home-manager.users."ominit".home.file.".config/zed/" = {
  #   source = ./config/.;
  #   recursive = true;
  # };

  users.users."ominit".packages = [inputs.zed.packages."${pkgs.system}".default];
}
