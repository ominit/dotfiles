{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkPackageOption;

  pkg = "ghostty";
in {
  config = mkIf config.modules.programs."${pkg}".enable {
    hjem.users."ominit" = {
      files.".config/ghostty" = {
        source = ./config;
        clobber = true;
      };

      packages = with pkgs; [
        config.modules.programs."${pkg}".package
      ];
    };
  };

  options.modules.programs."${pkg}" = {
    enable = mkEnableOption "enable ghostty";
    package = mkPackageOption pkgs "ghostty" {};
  };
}
