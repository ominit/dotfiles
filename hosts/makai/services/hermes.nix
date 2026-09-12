{
  config,
  lib,
  ...
}: let
  harness = lib.findFirst (harness: harness.name == "hermes") null config.modules.agents.harnesses;
  home = config.users.users.ominit.home;
  hermesHome = "${home}/.hermes";
  service = description: args: {
    inherit description;
    wantedBy = ["multi-user.target"];
    wants = ["network-online.target"];
    requires = ["hjem.target"];
    after = ["network-online.target" "hjem.target"];
    unitConfig.RequiresMountsFor = [home];

    environment = {
      HOME = home;
      HERMES_HOME = hermesHome;
    };

    path = [
      "${home}/.nix-profile"
      "/nix/profile"
      "${home}/.local/state/nix/profile"
      "/etc/profiles/per-user/ominit"
      "/nix/var/nix/profiles/default"
      "/run/current-system/sw"
    ];

    serviceConfig = {
      User = "ominit";
      Group = "users";
      WorkingDirectory = home;
      ExecStart = lib.escapeShellArgs (["${lib.getExe harness.package}"] ++ args);
      Restart = "always";
      RestartSec = "5s";
      TimeoutStopSec = "90s";
    };
  };
in {
  config = lib.mkIf (harness != null) {
    systemd.services = {
      hermes-agent = lib.recursiveUpdate (service "Hermes Agent gateway" ["gateway" "run"]) {
        serviceConfig.RestartPreventExitStatus = [78];
      };
      hermes-dashboard = service "Hermes Agent browser dashboard" [
        "dashboard"
        "--host"
        "127.0.0.1"
        "--port"
        "10010"
        "--no-open"
      ];
    };
  };
}
