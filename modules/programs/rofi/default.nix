{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkPackageOption;

  pkg = "rofi";
in {
  config = mkIf config.modules.programs."${pkg}".enable {
    hjem.users."ominit" = {
      files.".config/rofi/config.rasi" = {
        source = ./config/config.rasi;
        clobber = true;
      };

      packages = [
        config.modules.programs."${pkg}".package
      ];
    };
  };

  options.modules.programs."${pkg}" = {
    enable = mkEnableOption "enable rofi";
    package = mkPackageOption pkgs "rofi" {};
  };
}
