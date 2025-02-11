{
  pkgs,
  inputs,
  ...
}: {
  home-manager.users."ominit".home.file.".config/ghostty/" = {
    source = ./config/.;
    recursive = true;
  };

  users.users."ominit".packages = [inputs.ghostty.packages.${pkgs.system}.default];
}
