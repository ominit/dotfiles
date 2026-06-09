{
  config,
  lib,
  ...
}: let
  inherit (lib) attrValues concatLists mapAttrs' mkOption nameValuePair types;

  cfg = config.modules.persistence;

  bindMountType = types.submodule ({name, ...}: {
    options = {
      source = mkOption {
        type = types.str;
        default = "/data/persist/${name}";
        description = "Persistent backing directory for the bind mount.";
      };

      target = mkOption {
        type = types.str;
        description = "Path where the persistent directory is bind-mounted.";
      };

      user = mkOption {
        type = types.str;
        default = "root";
        description = "Owner for created source and target directories.";
      };

      group = mkOption {
        type = types.str;
        default = "root";
        description = "Group for created source and target directories.";
      };

      mode = mkOption {
        type = types.str;
        default = "0755";
        description = "Mode for created source and target directories.";
      };

      mountOptions = mkOption {
        type = types.listOf types.str;
        default = ["bind" "rw"];
        description = "Mount options for the bind mount.";
      };

      createSource = mkOption {
        type = types.bool;
        default = true;
        description = "Create the persistent backing directory with tmpfiles.";
      };

      createTarget = mkOption {
        type = types.bool;
        default = true;
        description = "Create the bind mount target directory with tmpfiles.";
      };

      resetPermissions = mkOption {
        type = types.bool;
        default = false;
        description = "Recursively reset ownership and permissions for the persistent backing directory.";
      };

      resetMode = mkOption {
        type = types.str;
        default = "-";
        description = "Mode to use when resetPermissions is enabled. Use '-' to preserve existing modes.";
      };
    };
  });

  mkTmpfiles = mount: let
    user = config.users.users.${mount.user}.name;
    group = config.users.groups.${mount.group}.name;
  in
    []
    ++ lib.optional mount.createSource "d ${mount.source} ${mount.mode} ${user} ${group} -"
    ++ lib.optional mount.createTarget "d ${mount.target} ${mount.mode} ${user} ${group} -"
    ++ lib.optional mount.resetPermissions "Z ${mount.source} ${mount.resetMode} ${user} ${group} -";
in {
  options.modules.persistence = {
    bindMounts = mkOption {
      type = types.attrsOf bindMountType;
      default = {};
      description = "Persistent bind mounts with matching tmpfiles directory creation.";
    };
  };

  config = {
    systemd.tmpfiles.rules = concatLists (map mkTmpfiles (attrValues cfg.bindMounts));

    fileSystems = mapAttrs' (_: mount:
      nameValuePair mount.target {
        device = mount.source;
        fsType = "none";
        options = mount.mountOptions;
      })
    cfg.bindMounts;
  };
}
