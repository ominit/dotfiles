{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (lib) getExe mapAttrsToList mkEnableOption mkIf mkOption types;

  cfg = config.modules.autodeploy;
  stateDir = "/var/lib/autodeploy";

  scriptsOption = description: extraOptions:
    mkOption {
      inherit description;
      default = {};
      type = types.attrsOf (types.submodule {
        options =
          {
            script = mkOption {
              type = types.lines;
              description = "Bash script. Exit 0 to pass. Its output is shown as the reason when it fails.";
            };
            path = mkOption {
              type = types.listOf types.package;
              default = [];
              description = "Packages on the script's PATH.";
            };
          }
          // extraOptions;
      });
    };

  commands = mapAttrsToList (name: script: {
    inherit name;
    units = script.units or [];
    command = getExe (pkgs.writeShellApplication {
      name = "autodeploy-${name}";
      runtimeInputs = script.path;
      text = script.script;
    });
  });

  sourceInfo = pkgs.writeText "autodeploy-source.json" (builtins.toJSON {
    rev = self.rev or null;
    dirtyRev = self.dirtyRev or null;
    inherit (self) narHash lastModified;
  });

  settings = pkgs.writeText "autodeploy.json" (builtins.toJSON {
    inherit stateDir;
    inherit (cfg) mode;
    hostname = config.networking.hostName;
    gates = commands cfg.gates;
    healthChecks = commands cfg.healthChecks;
  });
in {
  options.modules.autodeploy = {
    enable = mkEnableOption "deploying this host from the main branch";

    mode = mkOption {
      type = types.enum ["switch" "boot"];
      default = "switch";
      description = "`boot` only stages new configurations for the next boot, so gates and health checks are skipped.";
    };

    gates = scriptsOption "Checks that must all pass before switching. A failing gate holds the deploy until the next run. No gates run when the switch would stop or restart nothing." {
      units = mkOption {
        type = types.listOf types.str;
        default = [];
        example = ["t3code.service"];
        description = "Only run this gate when the switch would stop or restart one of these units. Empty means any unit.";
      };
    };

    healthChecks = scriptsOption "Checks that must pass after `switch-to-configuration test` before the configuration becomes the boot default." {};

    desktopNotifications = mkOption {
      type = types.bool;
      default = false;
      description = "Send desktop notifications when a generation is staged or a deploy fails.";
    };

    requireACPower = mkOption {
      type = types.bool;
      default = false;
      description = "Skip runs while on battery.";
    };
  };

  config = mkIf cfg.enable {
    system.systemBuilderCommands = ''
      ln -s ${sourceInfo} $out/autodeploy-source.json
    '';

    modules.autodeploy = {
      gates.sessions = {
        path = [pkgs.jq pkgs.systemd];
        script = ''
          active=$(loginctl list-sessions --json=short | jq -r '.[] | select(.class == "user" and (.tty // "" | startswith("pts/")) and .idle == false) | "\(.user) on \(.tty)"')
          if [ -n "$active" ]; then
            echo "$active" | paste -sd, -
            exit 1
          fi
        '';
      };

      healthChecks = {
        github = {
          path = [pkgs.curl];
          script = "curl -fsS --max-time 10 -o /dev/null https://api.github.com";
        };

        sshd = mkIf config.services.openssh.enable {
          path = [pkgs.systemd];
          script = "systemctl is-active --quiet sshd.service";
        };

        netbird = mkIf config.services.netbird.enable {
          path = [pkgs.jq config.services.netbird.package];
          script = "netbird status --json | jq -e '.management.connected and .signal.connected' > /dev/null";
        };
      };
    };

    systemd.services.autodeploy = {
      wants = ["network-online.target"];
      after = ["network-online.target"];
      restartIfChanged = false;
      stopIfChanged = false;
      unitConfig.ConditionACPower = mkIf cfg.requireACPower true;
      path = [config.nix.package pkgs.git pkgs.gnutar];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${getExe pkgs.nushell} --no-config-file ${./autodeploy.nu} ${settings}";
        StateDirectory = "autodeploy";
        StateDirectoryMode = "0755";
      };
    };

    systemd.timers.autodeploy = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "5min";
        OnUnitInactiveSec = "10min";
      };
    };

    systemd.user.paths.autodeploy-notify = mkIf cfg.desktopNotifications {
      wantedBy = ["default.target"];
      pathConfig.PathChanged = "${stateDir}/state.json";
    };

    systemd.user.services.autodeploy-notify = mkIf cfg.desktopNotifications {
      path = [pkgs.libnotify];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${getExe pkgs.nushell} --no-config-file ${./notify.nu} ${stateDir}/state.json";
      };
    };

    modules.programs.nushell.extraSources = [./autodeploy-greeting.nu];
  };
}
