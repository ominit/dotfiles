{
  lib,
  pkgs,
}: {
  package = pkgs.writeShellScriptBin "kraai" ''
    exec ${lib.getExe pkgs.nix} run github:kraai-io/kraai -- "$@"
  '';
  settingsType = (pkgs.formats.toml {}).type;

  configure = cfg: {
    package = cfg.package;
    files = lib.optionalAttrs (cfg.agentFiles != []) {
      ".kraai/AGENTS.md" = {
        text = lib.concatMapStringsSep "\n\n" builtins.readFile cfg.agentFiles;
        clobber = true;
      };
    };
    tmpfiles = ["d %h/.kraai 0700 - - -"];
  };
}
