{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) attrValues concatMapStringsSep mapAttrs' mkIf mkOption nameValuePair optionalString types;

  cfg = config.modules.persistence;

  directoryType = types.submodule ({name, ...}: {
    options = {
      source = mkOption {
        type = types.str;
        default = "/data/persist/${name}";
        description = "Persistent backing directory.";
      };

      target = mkOption {
        type = types.str;
        description = "Path where the persistent directory is bind-mounted.";
      };

      user = mkOption {
        type = types.str;
        default = "-";
        description = "Owner for created source and target directories. Use '-' to leave ownership unchanged.";
      };

      group = mkOption {
        type = types.str;
        default = "-";
        description = "Group for created source and target directories. Use '-' to leave ownership unchanged.";
      };

      mode = mkOption {
        type = types.str;
        default = "-";
        description = "Mode for created source and target directories. Use '-' to leave permissions unchanged.";
      };

      mountOptions = mkOption {
        type = types.listOf types.str;
        default = ["bind" "rw"];
        description = "Mount options for the bind mount.";
      };

      adoptOnStop = mkOption {
        type = types.bool;
        default = true;
        description = "Adopt the target into the persistent backing directory during service stop when the source does not exist.";
      };

      createTarget = mkOption {
        type = types.bool;
        default = true;
        description = "Create the bind mount target when restoring an existing persistent source.";
      };

      resetPermissions = mkOption {
        type = types.bool;
        default = false;
        description = "Recursively repair ownership and permissions for the persistent backing directory when it exists.";
      };

      resetMode = mkOption {
        type = types.str;
        default = "-";
        description = "Mode to use when resetPermissions is enabled. Use '-' to preserve existing modes.";
      };
    };
  });

  fileType = types.submodule ({name, ...}: {
    options = {
      source = mkOption {
        type = types.str;
        default = "/data/persist/${name}";
        description = "Persistent backing file.";
      };

      target = mkOption {
        type = types.str;
        description = "Path where the persistent file is bind-mounted.";
      };

      user = mkOption {
        type = types.str;
        default = "-";
        description = "Owner for created source and target paths. Use '-' to leave ownership unchanged.";
      };

      group = mkOption {
        type = types.str;
        default = "-";
        description = "Group for created source and target paths. Use '-' to leave ownership unchanged.";
      };

      mode = mkOption {
        type = types.str;
        default = "-";
        description = "Mode for created source and target files. Use '-' to leave permissions unchanged.";
      };

      directoryMode = mkOption {
        type = types.str;
        default = "-";
        description = "Mode for created source and target parent directories. Use '-' to leave permissions unchanged.";
      };

      mountOptions = mkOption {
        type = types.listOf types.str;
        default = ["bind" "rw"];
        description = "Mount options for the bind mount.";
      };

      adoptOnStop = mkOption {
        type = types.bool;
        default = true;
        description = "Adopt the target into the persistent backing file during service stop when the source does not exist.";
      };

      createTarget = mkOption {
        type = types.bool;
        default = true;
        description = "Create the bind mount target when restoring an existing persistent source.";
      };

      resetPermissions = mkOption {
        type = types.bool;
        default = false;
        description = "Repair ownership and permissions for the persistent backing file when it exists.";
      };

      resetMode = mkOption {
        type = types.str;
        default = "-";
        description = "Mode to use when resetPermissions is enabled. Use '-' to preserve existing modes.";
      };
    };
  });

  groupType = types.submodule {
    options = {
      source = mkOption {
        type = types.str;
        description = "Persistent backing directory containing the relative paths.";
      };

      target = mkOption {
        type = types.str;
        description = "Target directory containing the relative paths.";
      };

      directories = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Relative directory paths to bind mount.";
      };

      files = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Relative file paths to bind mount.";
      };

      user = mkOption {
        type = types.str;
        default = "-";
        description = "Owner for created source and target paths. Use '-' to leave ownership unchanged.";
      };

      group = mkOption {
        type = types.str;
        default = "-";
        description = "Group for created source and target paths. Use '-' to leave ownership unchanged.";
      };

      directoryMode = mkOption {
        type = types.str;
        default = "-";
        description = "Mode for created directories. Use '-' to leave permissions unchanged.";
      };

      fileMode = mkOption {
        type = types.str;
        default = "-";
        description = "Mode for created files. Use '-' to leave permissions unchanged.";
      };

      mountOptions = mkOption {
        type = types.listOf types.str;
        default = ["bind" "rw"];
        description = "Mount options for generated bind mounts.";
      };

      adoptOnStop = mkOption {
        type = types.bool;
        default = true;
        description = "Adopt missing relative paths from the target tree during service stop.";
      };
    };
  };

  joinPath = base: path: "${base}/${path}";

  mountName = groupName: kind: path: let
    escapedPath = lib.replaceStrings ["/" "."] ["-" "_"] path;
    pathHash = builtins.substring 0 8 (builtins.hashString "sha256" path);
  in "${groupName}-${kind}-${escapedPath}-${pathHash}";

  mkDirectoryMount = groupName: group: path:
    nameValuePair (mountName groupName "directory" path) {
      kind = "directory";
      source = joinPath group.source path;
      target = joinPath group.target path;
      sourceParent = builtins.dirOf (joinPath group.source path);
      sourceParentMode = group.directoryMode;
      user = group.user;
      group = group.group;
      mode = group.directoryMode;
      mountOptions = group.mountOptions;
      adoptOnStop = group.adoptOnStop;
      createTarget = true;
      resetPermissions = false;
      resetMode = "-";
    };

  mkFileMount = groupName: group: path:
    nameValuePair (mountName groupName "file" path) {
      kind = "file";
      source = joinPath group.source path;
      target = joinPath group.target path;
      sourceParent = builtins.dirOf (joinPath group.source path);
      targetParent = builtins.dirOf (joinPath group.target path);
      user = group.user;
      group = group.group;
      directoryMode = group.directoryMode;
      mode = group.fileMode;
      mountOptions = group.mountOptions;
      adoptOnStop = group.adoptOnStop;
      createTarget = true;
      resetPermissions = false;
      resetMode = "-";
    };

  groupBindMounts = lib.concatMapAttrs (groupName: group:
    builtins.listToAttrs (
      (map (mkDirectoryMount groupName group) group.directories)
      ++ (map (mkFileMount groupName group) group.files)
    ))
  cfg.groups;

  directoryMounts = mapAttrs' (name: mount:
    nameValuePair "directory-${name}" (mount
      // {
        kind = "directory";
        sourceParent = builtins.dirOf mount.source;
      }))
  cfg.directories;

  fileMounts = mapAttrs' (name: mount:
    nameValuePair "file-${name}" (mount
      // {
        kind = "file";
        sourceParent = builtins.dirOf mount.source;
        targetParent = builtins.dirOf mount.target;
      }))
  cfg.files;

  mounts = directoryMounts // fileMounts // groupBindMounts;

  resolveUser = user:
    if user == "-"
    then "-"
    else config.users.users.${user}.name;

  resolveGroup = group:
    if group == "-"
    then "-"
    else config.users.groups.${group}.name;

  chownArg = user: group:
    if user == "-" && group == "-"
    then null
    else if group == "-"
    then user
    else "${optionalString (user != "-") user}:${group}";

  applyMetadata = path: mode: user: group: let
    owner = chownArg user group;
    quotedPath = lib.escapeShellArg path;
  in ''
    ${optionalString (mode != "-") "chmod ${lib.escapeShellArg mode} ${quotedPath}"}
    ${optionalString (owner != null) "chown ${lib.escapeShellArg owner} ${quotedPath}"}
  '';

  applyTreeMetadata = path: mode: user: group: let
    owner = chownArg user group;
    quotedPath = lib.escapeShellArg path;
  in ''
    ${optionalString (mode != "-") "chmod -R ${lib.escapeShellArg mode} ${quotedPath}"}
    ${optionalString (owner != null) "chown -R ${lib.escapeShellArg owner} ${quotedPath}"}
  '';

  applySourceMetadata = mount: user: group: ''
    ${optionalString mount.resetPermissions (applyTreeMetadata mount.source mount.resetMode user group)}
    ${applyMetadata mount.source mount.mode user group}
  '';

  pathTest = kind: path:
    if kind == "file"
    then "[ -f ${lib.escapeShellArg path} ]"
    else "[ -d ${lib.escapeShellArg path} ]";

  mountCommand = mount: options: "mount -o ${lib.escapeShellArg options} ${lib.escapeShellArg mount.source} ${lib.escapeShellArg mount.target}";

  mountExistingSource = mount: kind: options:
    if mount.createTarget
    then mountCommand mount options
    else ''
      if ${pathTest kind mount.target}; then
        ${mountCommand mount options}
      fi
    '';

  mkRestoreScript = mount: let
    user = resolveUser mount.user;
    group = resolveGroup mount.group;
    kind = mount.kind or "directory";
    options = lib.concatStringsSep "," mount.mountOptions;
    sourceReady = pathTest kind mount.source;
    targetNotMounted = "! mountpoint -q ${lib.escapeShellArg mount.target}";
  in
    if kind == "file"
    then ''
      if ${sourceReady}; then
        ${applySourceMetadata mount user group}
        if ${targetNotMounted}; then
          ${optionalString mount.createTarget ''
        mkdir -p ${lib.escapeShellArg mount.targetParent}
        ${applyMetadata mount.targetParent mount.directoryMode user group}
          touch ${lib.escapeShellArg mount.target}
          ${applyMetadata mount.target mount.mode user group}
      ''}
          ${mountExistingSource mount kind options}
        fi
      fi
    ''
    else ''
      if ${sourceReady}; then
        ${applySourceMetadata mount user group}
        if ${targetNotMounted}; then
          ${optionalString mount.createTarget ''
        mkdir -p ${lib.escapeShellArg mount.target}
        ${applyMetadata mount.target mount.mode user group}
      ''}
          ${mountExistingSource mount kind options}
        fi
      fi
    '';

  mkAdoptScript = mount: let
    user = resolveUser mount.user;
    group = resolveGroup mount.group;
    kind = mount.kind or "directory";
    sourceParent = mount.sourceParent or (builtins.dirOf mount.source);
    sourceParentMetadata = optionalString (mount ? sourceParentMode) (applyMetadata sourceParent mount.sourceParentMode user group);
    targetReady = pathTest kind mount.target;
    targetNotMounted = "! mountpoint -q ${lib.escapeShellArg mount.target}";
  in
    if ! mount.adoptOnStop
    then ""
    else if kind == "file"
    then ''
      if [ ! -e ${lib.escapeShellArg mount.source} ] && ${targetReady} && ${targetNotMounted}; then
        mkdir -p ${lib.escapeShellArg sourceParent}
        ${applyMetadata sourceParent mount.directoryMode user group}
        cp -a ${lib.escapeShellArg mount.target} ${lib.escapeShellArg mount.source}
        ${applySourceMetadata mount user group}
      fi
    ''
    else ''
      if [ ! -e ${lib.escapeShellArg mount.source} ] && ${targetReady} && ${targetNotMounted}; then
        mkdir -p ${lib.escapeShellArg sourceParent}
        ${sourceParentMetadata}
        cp -aT ${lib.escapeShellArg mount.target} ${lib.escapeShellArg mount.source}
        ${applySourceMetadata mount user group}
      fi
    '';
in {
  options.modules.persistence = {
    directories = mkOption {
      type = types.attrsOf directoryType;
      default = {};
      description = "Directory bind mounts restored from existing persistent sources and adopted on stop when sources are missing.";
    };

    files = mkOption {
      type = types.attrsOf fileType;
      default = {};
      description = "File bind mounts restored from existing persistent sources and adopted on stop when sources are missing.";
    };

    groups = mkOption {
      type = types.attrsOf groupType;
      default = {};
      description = "Grouped persistence roots with relative directory and file bind mounts.";
    };
  };

  config = mkIf (mounts != {}) {
    systemd.services.persistence-bind-mounts = {
      description = "Restore existing persistence bind mounts and adopt missing sources";
      requiredBy = ["basic.target"];
      before = [
        "basic.target"
        "shutdown.target"
      ];
      after = ["local-fs.target"];
      conflicts = ["shutdown.target"];
      restartIfChanged = false;
      stopIfChanged = false;
      unitConfig = {
        DefaultDependencies = false;
        RequiresMountsFor = map (mount: mount.source) (attrValues mounts);
      };
      path = [
        pkgs.coreutils
        pkgs.util-linux
      ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = concatMapStringsSep "\n" mkRestoreScript (attrValues mounts);
      preStop = concatMapStringsSep "\n" mkAdoptScript (attrValues mounts);
    };
  };
}
