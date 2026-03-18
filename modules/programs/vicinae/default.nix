{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkPackageOption;

  pkg = "vicinae";
in {
  config = mkIf config.modules.programs."${pkg}".enable {
    hjem.users."ominit" = {
      files.".local/share/vicinae/themes/embark.toml" = {
        source = ./config/embark.toml;
        clobber = true;
      };

      packages = [
        config.modules.programs."${pkg}".package
      ];
    };
  };

  options.modules.programs."${pkg}" = {
    enable = mkEnableOption "enable vicinae";
    package = mkPackageOption pkgs "vicinae" {};
  };
}
