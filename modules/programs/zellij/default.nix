{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkPackageOption;

  pkg = "zellij";
in {
  config = mkIf config.modules.programs."${pkg}".enable {
    hjem.users."ominit" = {
      files.".config/zellij" = {
        source = ./config;
        clobber = true;
      };

      packages = [
        config.modules.programs."${pkg}".package
      ];
    };
  };

  options.modules.programs."${pkg}" = {
    enable = mkEnableOption "enable zellij";
    package = mkPackageOption pkgs "zellij" {};
  };
}
