{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption mkPackageOption;

  pkg = "btop";
in {
  config = mkIf config.modules.programs."${pkg}".enable {
    hjem.users."ominit" = {
      files.".config/btop" = {
        source = ./config;
        clobber = true;
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
