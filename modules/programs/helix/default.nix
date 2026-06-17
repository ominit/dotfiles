{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkPackageOption;

  pkg = "helix";
in {
  config = mkIf config.modules.programs."${pkg}".enable {
    nix.settings.substituters = [
      "https://helix.cachix.org"
    ];
    nix.settings.trusted-public-keys = [
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
    ];

    hjem.users."ominit" = {
      files = {
        ".config/helix/config.toml" = {
          source = ./config/config.toml;
          clobber = true;
        };

        ".config/helix/languages.toml" = {
          source = ./config/languages.toml;
          clobber = true;
        };

        ".config/helix/themes/embark.toml" = {
          source = ./config/themes/embark.toml;
          clobber = true;
        };
      };

      packages = with pkgs; [
        config.modules.programs."${pkg}".package

        # lsp
        nixd
        taplo

        # formatter
        alejandra
      ];
    };
  };

  options.modules.programs."${pkg}" = {
    enable = mkEnableOption "enable helix";
    package = mkPackageOption pkgs "helix" {};
  };
}
