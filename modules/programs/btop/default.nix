{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkPackageOption;

  pkg = "btop";
in {
  config = mkIf config.modules.programs."${pkg}".enable {
    hjem.users."ominit" = {
      files = {
        ".config/btop/btop.conf" = {
          source = ./config/btop.conf;
          clobber = true;
        };

        ".config/btop/themes/embark.theme" = {
          source = ./config/themes/embark.theme;
          clobber = true;
        };
      };

      packages = with pkgs; [
        config.modules.programs."${pkg}".package
      ];
    };
  };

  options.modules.programs."${pkg}" = {
    enable = mkEnableOption "enable btop";
    package = mkPackageOption pkgs "btop" {};
  };
}
