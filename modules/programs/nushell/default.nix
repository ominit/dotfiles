{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption mkPackageOption;

  pkg = "nushell";
in {
  config = mkIf config.modules.programs."${pkg}".enable {
    hjem.users."ominit" = {
      # nushell requires write access to its config dir, so symlink the files
      files.".config/nushell/config.nu" = {
        source = ./config/config.nu;
        clobber = true;
      };

      files.".config/nushell/autoload/starship.nu" = {
        source = ./config/autoload/starship.nu;
        clobber = true;
      };

      packages = with pkgs; [
        config.modules.programs."${pkg}".package

        starship
        fish
        carapace
      ];
    };
  };

  options.modules.programs."${pkg}" = {
    enable = mkEnableOption "enable nushell";
    package = mkPackageOption pkgs "nushell" {};
  };
}
