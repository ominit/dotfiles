{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkPackageOption;

  pkg = "noctalia";
in {
  config = mkIf config.modules.programs."${pkg}".enable {
    hjem.users."ominit" = {
      files.".config/noctalia/settings.json" = {
        source = ./config/settings.json;
        clobber = true;
      };

      files.".config/noctalia/colorschemes/Embark/Embark.json" = {
        source = ./config/colorschemes/Embark/Embark.json;
        clobber = true;
      };

      packages =
        [
          config.modules.programs."${pkg}".package
        ]
        ++ (with pkgs; [
          # gtk theming
          adw-gtk3
          nwg-look
          # qt theming
          qt6Packages.qt6ct
        ]);
    };
  };

  options.modules.programs."${pkg}" = {
    enable = mkEnableOption "enable noctalia";
    package = mkPackageOption pkgs "noctalia-shell" {};
  };
}
