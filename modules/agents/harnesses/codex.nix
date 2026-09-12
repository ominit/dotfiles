{
  lib,
  pkgs,
}: {
  package = pkgs.codex;
  settingsType = (pkgs.formats.toml {}).type;

  configure = cfg: let
    toToml = value:
      if builtins.isAttrs value
      then "{ ${lib.concatStringsSep ", " (lib.mapAttrsToList (name: child: "${builtins.toJSON name} = ${toToml child}") value)} }"
      else if builtins.isList value
      then "[${lib.concatMapStringsSep ", " toToml value}]"
      else builtins.toJSON value;
    # Codex expects unquoted dotted keys for CLI overrides.
    configFlags = path: value:
      if builtins.isAttrs value
      then lib.concatLists (lib.mapAttrsToList (name: child: configFlags (path ++ [name]) child) value)
      else ["-c" "${lib.concatStringsSep "." path}=${toToml value}"];
    settings =
      lib.recursiveUpdate (lib.optionalAttrs (cfg.mcpServers != {}) {
        mcp_servers = cfg.mcpServers;
        mcp_oauth_credentials_store = "file";
        mcp_oauth_callback_port = 53682;
      })
      cfg.settings;
    flags = configFlags [] settings;
    package =
      if flags == []
      then cfg.package
      else
        pkgs.writeShellScriptBin "codex" ''
          if [ "''${1-}" = "app-server" ]; then
            shift
            exec ${lib.getExe cfg.package} app-server ${lib.escapeShellArgs flags} "$@"
          fi
          exec ${lib.getExe cfg.package} ${lib.escapeShellArgs flags} "$@"
        '';
  in {
    inherit package;

    files =
      lib.optionalAttrs (cfg.agentFiles != []) {
        ".codex/AGENTS.md" = {
          text = lib.concatMapStringsSep "\n\n" builtins.readFile cfg.agentFiles;
          clobber = true;
        };
      }
      // lib.mapAttrs' (name: source:
        lib.nameValuePair ".codex/skills/${name}" {
          inherit source;
          clobber = true;
        })
      cfg.skills;

    tmpfiles = [
      "d %h/.codex 0700 - - -"
      "d %h/.codex/skills 0700 - - -"
    ];
  };
}
