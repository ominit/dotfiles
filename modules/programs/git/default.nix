{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption mkPackageOption mkMerge;
  inherit (lib.strings) concatStrings;

  pkg = "git";
in {
  config = mkIf config.modules.programs."${pkg}".enable {
    hjem.users."ominit" = {
      files.".config/git/config" = {
        text = concatStrings [
          ''
            [user]
            email = "86736586+ominit@users.noreply.github.com"
            name = "ominit"
          ''
          (
            if config.modules.programs."${pkg}".delta-pager
            then ''
              [core]
              pager = "delta"

              [delta]
              dark = true
              line-numbers = true

              [interactive]
              diffFilter = "delta --color-only"
            ''
            else ""
          )
        ];
        clobber = true;
      };

      packages =
        [
          config.modules.programs."${pkg}".package
        ]
        ++ (
          if config.modules.programs."${pkg}".delta-pager
          then [pkgs.delta]
          else []
        );
    };
  };

  options.modules.programs."${pkg}" = {
    enable = mkEnableOption "enable git";
    package = mkPackageOption pkgs "git" {};
    delta-pager = mkEnableOption "enable delta pager for git";
  };
}
