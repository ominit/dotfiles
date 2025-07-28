{
  config,
  lib,
  pkgs,
  ...
}: {
  config = {
    sops.secrets."newtEnv" = {};

    systemd.services.newt = {
      description = "Newt, user space tunnel client for Pangolin";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];

      environment = {
        HOME = "/var/lib/private/newt";
      };
      # the flag values will all be overwritten if also defined in the env file
      script = "
        exec ${lib.getExe pkgs.fosrl-newt} --secret $NEWT_SECRET --endpoint $PANGOLIN_ENDPOINT --id $NEWT_ID --log-level INFO
      ";
      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "newt";
        StateDirectoryMode = "0700";
        Restart = "always";
        RestartSec = "10s";
        EnvironmentFile = config.sops.secrets."newtEnv".path;
        # hardening
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = "disconnected";
        PrivateDevices = true;
        PrivateUsers = true;
        PrivateMounts = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        LockPersonality = true;
        RestrictRealtime = true;
        ProtectClock = true;
        ProtectProc = "noaccess";
        ProtectHostname = true;
        RemoveIPC = true;
        NoNewPrivileges = true;
        RestrictSUIDSGID = true;
        MemoryDenyWriteExecute = true;
        SystemCallArchitectures = "native";
        UMask = "0077";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
          "AF_UNIX"
        ];
        CapabilityBoundingSet = [
          "~CAP_BLOCK_SUSPEND"
          "~CAP_BPF"
          "~CAP_CHOWN"
          "~CAP_MKNOD"
          "~CAP_NET_RAW"
          "~CAP_PERFMON"
          "~CAP_SYS_BOOT"
          "~CAP_SYS_CHROOT"
          "~CAP_SYS_MODULE"
          "~CAP_SYS_NICE"
          "~CAP_SYS_PACCT"
          "~CAP_SYS_PTRACE"
          "~CAP_SYS_TIME"
          "~CAP_SYS_TTY_CONFIG"
          "~CAP_SYSLOG"
          "~CAP_WAKE_ALARM"
        ];
        SystemCallFilter = [
          "~@aio:EPERM"
          "~@chown:EPERM"
          "~@clock:EPERM"
          "~@cpu-emulation:EPERM"
          "~@debug:EPERM"
          "~@keyring:EPERM"
          "~@memlock:EPERM"
          "~@module:EPERM"
          "~@mount:EPERM"
          "~@obsolete:EPERM"
          "~@pkey:EPERM"
          "~@privileged:EPERM"
          "~@raw-io:EPERM"
          "~@reboot:EPERM"
          "~@resources:EPERM"
          "~@sandbox:EPERM"
          "~@setuid:EPERM"
          "~@swap:EPERM"
          "~@sync:EPERM"
          "~@timer:EPERM"
        ];
      };
    };
  };
}
