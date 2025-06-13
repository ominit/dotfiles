{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption mkPackageOption;
in {
  config = mkIf config.modules.programs.helix.enable {
    hjem.users."ominit" = {
      files.".config/helix/" = {
        source = ./config;
        clobber = true;
      };

      packages = with pkgs; [
        config.modules.programs.helix.package

        # lsp
        nixd
        taplo

        # formatter
        alejandra
      ];
    };
  };

  options.modules.programs.helix = {
    enable = mkEnableOption "enable helix";
    package = mkPackageOption pkgs "helix" {};
  };
}
