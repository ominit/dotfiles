{
  lib,
  pkgs,
}: {
  package = pkgs.claude-code;
  settingsType = (pkgs.formats.json {}).type;

  configure = cfg: let
    json = pkgs.formats.json {};
    mcpConfig = json.generate "claude-mcp.json" {
      mcpServers = lib.mapAttrs (_: server: {type = "http";} // server) cfg.mcpServers;
    };
    settings = json.generate "claude-settings.json" cfg.settings;
    flags =
      lib.optionals (cfg.mcpServers != {}) ["--mcp-config" "${mcpConfig}"]
      ++ lib.optionals (cfg.settings != {}) ["--settings" "${settings}"];
    package =
      if flags == []
      then cfg.package
      else
        pkgs.writeShellScriptBin "claude" ''
          exec ${lib.getExe cfg.package} ${lib.escapeShellArgs flags} "$@"
        '';
  in {
    inherit package;

    files =
      lib.optionalAttrs (cfg.agentFiles != []) {
        ".claude/CLAUDE.md" = {
          text = lib.concatMapStringsSep "\n\n" builtins.readFile cfg.agentFiles;
          clobber = true;
        };
      }
      // lib.mapAttrs' (name: source:
        lib.nameValuePair ".claude/skills/${name}" {
          inherit source;
          clobber = true;
        })
      cfg.skills;

    tmpfiles = [
      "d %h/.claude 0700 - - -"
      "d %h/.claude/skills 0700 - - -"
    ];
  };
}
