{
  inputs,
  system,
  lib,
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
      host = "0.0.0.0";
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
