{
  inputs,
  lib,
  pkgs,
}: let
  yaml = pkgs.formats.yaml {};
in {
  package = inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.minimal;
  settingsType = yaml.type;

  configure = cfg: {
    inherit (cfg) package;

    files =
      {
        ".hermes/config.yaml" = {
          source = yaml.generate "hermes-config.yaml" (lib.recursiveUpdate {
              mcp_servers = cfg.mcpServers;
            }
            cfg.settings);
          clobber = true;
        };
      }
      // lib.optionalAttrs (cfg.agentFiles != []) {
        ".hermes/SOUL.md" = {
          text = lib.concatMapStringsSep "\n\n" builtins.readFile cfg.agentFiles;
          clobber = true;
        };
      }
      // lib.mapAttrs' (name: source:
        lib.nameValuePair ".hermes/skills/${name}" {
          inherit source;
          clobber = true;
        })
      cfg.skills;

    tmpfiles = [
      "d %h/.hermes 0700 - - -"
      "d %h/.hermes/skills 0700 - - -"
    ];
  };
}
