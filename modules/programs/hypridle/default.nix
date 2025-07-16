{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkPackageOption;

  pkg = "hypridle";
in {
  config = mkIf config.modules.programs."${pkg}".enable {
    hjem.users."ominit" = {
      files.".config/hypr/hypridle.conf" = {
        source = ./config/hypridle.conf;
        clobber = true;
      };

      packages = [
        config.modules.programs."${pkg}".package
      ];
    };
  };

  options.modules.programs."${pkg}" = {
    enable = mkEnableOption "enable hypridle";
    package = mkPackageOption pkgs "hypridle" {};
  };
}
