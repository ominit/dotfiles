{
  lib,
  pkgs,
  ...
}: let
  lmsConfig = pkgs.runCommand "lms.conf" {} ''
    cp ${pkgs.lms}/share/lms/lms.conf $out
    substituteInPlace $out \
      --replace-fail 'working-dir = "/var/lms";' 'working-dir = "/var/lib/lms";' \
      --replace-fail 'listen-port = 5082;' 'listen-port = 10001;' \
      --replace-fail 'behind-reverse-proxy = false;' 'behind-reverse-proxy = true;' \
      --replace-fail 'jukebox-audio-backend = "auto";' 'jukebox-audio-backend = "none";'
  '';
in {
  config = {
    systemd.services.lms = {
      description = "Lightweight Music Server";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      environment.OMP_THREAD_LIMIT = "1";

      unitConfig.RequiresMountsFor = [
        "/data/storage/lms"
        "/var/lib/lms"
      ];

      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.lms} ${lmsConfig}";
        User = "lms";
        Group = "lms";
        StateDirectory = "lms";
        StateDirectoryMode = "0750";
        WorkingDirectory = "/var/lib/lms";
        Restart = "on-failure";
        RestartSec = "1s";
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        ReadWritePaths = ["/var/lib/lms"];
      };
    };

    modules.persistence.directories.lms = {
      source = "/data/services/lms";
      target = "/var/lib/lms";
      user = "lms";
      group = "lms";
      resetPermissions = true;
    };

    users.users.lms = {
      isSystemUser = true;
      group = "lms";
    };

    users.groups.lms = {};
  };
}
