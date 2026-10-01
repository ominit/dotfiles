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
