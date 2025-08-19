{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkPackageOption;

  pkg = "quickshell";
in {
  config = mkIf config.modules.programs."${pkg}".enable {
    hjem.users."ominit" = {
      # files.".config/quickshell" = {
      #   source = ./config;
      #   clobber = true;
      # };

      packages = with pkgs; [
        config.modules.programs."${pkg}".package
        kdePackages.full
      ];
    };
  };

  options.modules.programs."${pkg}" = {
    enable = mkEnableOption "enable quickshell";
    package = mkPackageOption pkgs "quickshell" {};
  };
}
