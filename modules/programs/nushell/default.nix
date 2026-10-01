{
  pkgs,
  lib,
  config,
  inputs,
  system,
  ...
}: let
  inherit (lib) types mkIf mkEnableOption mkOption mkPackageOption mkMerge;

  pkg = "nushell";
  cade = inputs.cade.packages.${system}.default;
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
          ".config/nushell/autoload/cade.nu" = {
            source = pkgs.runCommand "cade.nu" {} ''
              ${lib.getExe cade} hook nushell > "$out"
            '';
            clobber = true;
          };

          ".config/nushell/autoload/starship.nu" = {
            source = pkgs.runCommand "starship.nu" {} ''
              ${lib.getExe pkgs.starship} init nu > "$out"
            '';
            clobber = true;
          };
        }
        (builtins.listToAttrs (map (p: {
            name = ".config/nushell/autoload/${baseNameOf p}";
            value = {
              source = p;
              clobber = true;
            };
          })
          config.modules.programs."${pkg}".extraSources))
      ];

      packages = with pkgs; [
        config.modules.programs."${pkg}".package
        cade

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
