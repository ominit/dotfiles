{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption nameValuePair types;

  cfg = config.modules.agents;
  mcpRoot = ./mcp;
  availableMcpServers = map (lib.removeSuffix ".nix") (builtins.attrNames (
    lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) (builtins.readDir mcpRoot)
  ));
  enabledMcpServers = builtins.listToAttrs (map (name:
    nameValuePair name (import (mcpRoot + "/${name}.nix")))
  cfg.mcpServers);
  # Codex expects unquoted dotted keys for CLI overrides.
  configFlags = path: value:
    if builtins.isAttrs value
    then lib.concatLists (lib.mapAttrsToList (name: child: configFlags (path ++ [name]) child) value)
    else ["-c" "${lib.concatStringsSep "." path}=${builtins.toJSON value}"];
  mcpFlags = configFlags [] {
    mcp_servers = enabledMcpServers;
    mcp_oauth_credentials_store = "file";
    mcp_oauth_callback_port = 53682;
  };
  codexWithMcp = pkgs.writeShellScriptBin "codex" ''
    exec ${lib.getExe cfg.codexPackage} ${lib.escapeShellArgs mcpFlags} "$@"
  '';
  skillRoot = ./skills;
  availableSkills = builtins.attrNames (
    lib.filterAttrs (_: type: type == "directory") (builtins.readDir skillRoot)
  );
  enabledSkillFiles = builtins.listToAttrs (map (name:
    nameValuePair ".agents/skills/${name}" {
      source = skillRoot + "/${name}";
      clobber = true;
    })
  cfg.skills);
  agentFiles = [./AGENTS.md] ++ cfg.extraAgentFiles;
in {
  options.modules.agents = {
    enable = mkEnableOption "agent configuration";

    skills = mkOption {
      type = types.listOf (types.enum availableSkills);
      default = [];
      apply = lib.unique;
      description = "Skills to expose in the user's shared agent skills directory.";
    };

    extraAgentFiles = mkOption {
      type = types.listOf types.path;
      default = [];
      description = "Additional AGENTS.md fragments appended after the shared defaults.";
    };

    mcpServers = mkOption {
      type = types.listOf (types.enum availableMcpServers);
      default = [];
      apply = lib.unique;
      description = "MCP servers to configure for Codex on this host. Authenticate separately on each host.";
    };

    codexPackage = mkOption {
      type = types.nullOr types.package;
      default = null;
      description = "Optional Codex package to install, wrapped when MCP servers are selected.";
    };
  };

  config = mkIf cfg.enable {
    users.users.ominit.packages = lib.optional (cfg.codexPackage != null) (
      if cfg.mcpServers != []
      then codexWithMcp
      else cfg.codexPackage
    );

    hjem.users."ominit".files =
      {
        ".codex/AGENTS.md" = {
          text = lib.concatMapStringsSep "\n\n" builtins.readFile agentFiles;
          clobber = true;
        };
      }
      // enabledSkillFiles;

    systemd.user.tmpfiles.users."ominit".rules = [
      "d %h/.agents/skills 0700 - - -"
      "d %h/.codex 0700 - - -"
    ];
  };
}
