{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) types mkIf mkEnableOption mkOption mkPackageOption mkMerge;

  pkg = "nushell";
in {
  config = mkIf config.modules.programs."${pkg}".enable {
    hjem.users."ominit" = {
      files = mkMerge [
        {
          ".config/nushell/config.nu" = {
            source = ./config/config.nu;
            clobber = true;
          };
        }
        {
          ".config/nushell/autoload/starship.nu" = {
            source = ./config/autoload/starship.nu;
            clobber = true;
          };
        }
        (builtins.listToAttrs (map (p: {
            name = ".config/nushell/autoload/${builtins.baseNameOf p}";
            value = {
              source = p;
              clobber = true;
            };
          })
          config.modules.programs."${pkg}".extraSources))
      ];

      packages = with pkgs; [
        config.modules.programs."${pkg}".package

        starship
        fish
        carapace
      ];
    };
  };

  options.modules.programs."${pkg}" = {
    enable = mkEnableOption "enable nushell";
    package = mkPackageOption pkgs "nushell" {};
    extraSources = mkOption {
      type = types.listOf types.path;
      default = [];
    };
  };
}
