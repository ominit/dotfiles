{
  lib,
  pkgs,
}: {
  package = pkgs.opencode;
  settingsType = (pkgs.formats.json {}).type;

  configure = cfg: let
    json = pkgs.formats.json {};
    settings =
      lib.recursiveUpdate (lib.optionalAttrs (cfg.mcpServers != {}) {
        mcp = lib.mapAttrs (_: server:
          if server ? url
          then {
            type = "remote";
            inherit (server) url;
          }
          else
            {
              type = "local";
              command = [server.command] ++ (server.args or []);
            }
            // lib.optionalAttrs (server ? env) {environment = server.env;})
        cfg.mcpServers;
      })
      cfg.settings;
    config = json.generate "opencode.json" settings;
    package =
      if settings == {}
      then cfg.package
      else
        pkgs.writeShellScriptBin "opencode" ''
          export OPENCODE_CONFIG=${config}
          exec ${lib.getExe cfg.package} "$@"
        '';
  in {
    inherit package;

    files =
      lib.optionalAttrs (cfg.agentFiles != []) {
        ".config/opencode/AGENTS.md" = {
          text = lib.concatMapStringsSep "\n\n" builtins.readFile cfg.agentFiles;
          clobber = true;
        };
      }
      // lib.mapAttrs' (name: source:
        lib.nameValuePair ".config/opencode/skills/${name}" {
          inherit source;
          clobber = true;
        })
      cfg.skills;

    tmpfiles = [
      "d %h/.config/opencode 0700 - - -"
      "d %h/.config/opencode/skills 0700 - - -"
    ];
  };
}
