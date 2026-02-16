{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkPackageOption;

  pkg = "jujutsu";
in {
  config = mkIf config.modules.programs."${pkg}".enable {
    hjem.users."ominit" = {
      files.".config/jj/config.toml" = {
        source = ./config/config.toml;
        clobber = true;
      };

      packages = [
        config.modules.programs."${pkg}".package

        pkgs.delta
        pkgs.diffedit3
      ];
    };
  };

  options.modules.programs."${pkg}" = {
    enable = mkEnableOption "enable jujutsu";
    package = mkPackageOption pkgs "jujutsu" {};
  };
}
