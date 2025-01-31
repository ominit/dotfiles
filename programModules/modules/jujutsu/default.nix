{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  home-manager.users."ominit".home.file.".config/nushell/completions-jj.nu" = lib.mkIf config.myPrograms.nushell.enable {
    source = ./completions-jj.nu;
  };

  home-manager.users."ominit".home.file.".config/jj/" = {
    source = ./config/.;
    recursive = true;
  };

  users.users."ominit".packages = [inputs.jujutsu.packages.${pkgs.system}.default];
}
