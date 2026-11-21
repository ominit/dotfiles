{
  config,
  inputs,
  system,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.t3code.nixosModules.default];

  config = {
    services.t3code = {
      enable = true;
      package = inputs.t3code.packages.${system}.t3code-nightly;
      user = "ominit";
      group = "users";
      createUser = false;
      dataDir = "/home/ominit/.t3";
      host = "127.0.0.1";
      port = 10009;
      environment = {
        HOME = "/home/ominit";
        CUA_DRIVER_RS_TELEMETRY_ENABLED = "0";
        XDG_RUNTIME_DIR = "/run/user/1000";
        DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/1000/bus";
        WAYLAND_DISPLAY = "wayland-session";
        SWAYSOCK = "/run/user/1000/sway-ipc.sock";
      };
    };

    modules.pangolin.resources.talkative-lesser-egyptian-jerboa = {
      name = "makai.t3code";
      domain = "makai.t3code.42nd.net";
      inherit (config.services.t3code) port;
      sso = false;
      healthPath = "/healthz";
    };

    modules.autodeploy.gates.t3code = {
      units = ["t3code.service"];
      path = [pkgs.sqlite];
      script = ''
        runs=$(sqlite3 -readonly "${config.services.t3code.dataDir}/userdata/statev2.sqlite" \
          "select count(*) from orchestration_v2_projection_runs where status in ('queued', 'preparing', 'starting', 'running', 'waiting')")
        if [ "$runs" -gt 0 ]; then
          echo "$runs running"
          exit 1
        fi
      '';
    };

    systemd.services.t3code.path = lib.mkAfter [
      "/home/ominit/.nix-profile"
      "/nix/profile"
      "/home/ominit/.local/state/nix/profile"
      "/etc/profiles/per-user/ominit"
      "/nix/var/nix/profiles/default"
      "/run/current-system/sw"
    ];
  };
}
