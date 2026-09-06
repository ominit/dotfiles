{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption nameValuePair types;

  cfg = config.modules.agents;
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
  };

  config = mkIf cfg.enable {
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
