{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption nameValuePair types;

  cfg = config.modules.agents;
  harnessRoot = ./harnesses;
  nixFiles = root:
    lib.mapAttrs' (name: _: nameValuePair (lib.removeSuffix ".nix" name) (root + "/${name}")) (
      lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) (builtins.readDir root)
    );
  harnesses = lib.mapAttrs (_: path: lib.callPackageWith {inherit inputs lib pkgs;} path {}) (nixFiles harnessRoot);
  mcpServers = lib.mapAttrs (_: path: import path) (nixFiles ./mcp);
  skills = lib.mapAttrs (name: _: ./skills + "/${name}") (
    lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./skills)
  );
  enabledHarnesses = map (harness:
    harnesses.${harness.name}.configure (harness
      // {
        mcpServers = lib.getAttrs harness.mcpServers mcpServers;
        skills = lib.getAttrs harness.skills skills;
      }))
  cfg.harnesses;
in {
  options.modules.agents.harnesses = mkOption {
    type = types.listOf (types.submodule ({config, ...}: {
      options = {
        name = mkOption {
          type = types.enum (builtins.attrNames harnesses);
          description = "Agent harness to install and configure.";
        };

        package = mkOption {
          type = types.package;
          default = harnesses.${config.name}.package;
          description = "Package to install for this harness.";
        };

        skills = mkOption {
          type = types.listOf (types.enum (builtins.attrNames skills));
          default = [];
          apply = lib.unique;
          description = "Skills to install for this harness.";
        };

        agentFiles = mkOption {
          type = types.listOf types.path;
          default = [];
          description = "Instruction files to concatenate in order for this harness.";
        };

        mcpServers = mkOption {
          type = types.listOf (types.enum (builtins.attrNames mcpServers));
          default = [];
          apply = lib.unique;
          description = "MCP servers to configure for this harness. Authenticate separately on each host.";
        };

        settings = mkOption {
          type = harnesses.${config.name}.settingsType;
          default = {};
          description = "Native harness settings, overriding the generated defaults.";
        };
      };
    }));
    default = [];
    description = "Harnesses to install, each with its own configuration.";
  };

  config = lib.mkIf (cfg.harnesses != []) {
    assertions = [
      {
        assertion = let
          names = map (harness: harness.name) cfg.harnesses;
        in
          builtins.length names == builtins.length (lib.unique names);
        message = "modules.agents.harnesses must contain each harness at most once.";
      }
    ];

    users.users.ominit.packages = map (harness: harness.package) enabledHarnesses;
    hjem.users.ominit.files = lib.mkMerge (map (harness: harness.files) enabledHarnesses);
    systemd.user.tmpfiles.users.ominit.rules = lib.concatMap (harness: harness.tmpfiles) enabledHarnesses;
  };
}
