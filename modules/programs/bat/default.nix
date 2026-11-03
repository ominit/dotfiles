{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkPackageOption;

  pkg = "bat";
  cache = pkgs.runCommand "bat-cache" {} ''
    ${lib.getExe config.modules.programs."${pkg}".package} cache --build --source ${./config} --target "$out"
  '';
in {
  config = mkIf config.modules.programs."${pkg}".enable {
    environment.sessionVariables.BAT_CACHE_PATH = "${cache}";

    hjem.users."ominit" = {
      files = {
        ".config/bat/config" = {
          source = ./config/config;
          clobber = true;
        };

        ".config/bat/themes/Embark.tmTheme" = {
          source = ./config/themes/Embark.tmTheme;
          clobber = true;
        };
      };

      packages = with pkgs; [
        config.modules.programs."${pkg}".package
      ];
    };
  };

  options.modules.programs."${pkg}" = {
    enable = mkEnableOption "enable bat";
    package = mkPackageOption pkgs "bat" {};
  };
}
