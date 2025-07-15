{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkPackageOption;

  pkg = "niri";
in {
  imports = [inputs.niri.nixosModules.niri];

  config = mkIf config.modules.programs."${pkg}".enable {
    hjem.users."ominit" = {
      files.".config/niri" = {
        source = ./config;
        clobber = true;
      };
    };

    programs.niri = {
      enable = true;
      package = config.modules.programs."${pkg}".package;
    };

    niri-flake.cache.enable = true;

    nixpkgs.overlays = [inputs.niri.overlays.niri];

    modules.programs.hyprlock.enable = true;
  };

  options.modules.programs."${pkg}" = {
    enable = mkEnableOption "enable niri";
    package = mkPackageOption pkgs "niri-stable" {};
  };
}
