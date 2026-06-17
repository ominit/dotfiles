{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkPackageOption;

  pkg = "yazi";
in {
  config = mkIf config.modules.programs."${pkg}".enable {
    hjem.users."ominit" = {
      files.".config/yazi/yazi.toml" = {
        source = ./config/yazi.toml;
        clobber = true;
      };

      packages = with pkgs; [
        config.modules.programs."${pkg}".package
      ];
    };
  };

  options.modules.programs."${pkg}" = {
    enable = mkEnableOption "enable yazi";
    package = mkPackageOption pkgs "yazi" {};
  };
}
