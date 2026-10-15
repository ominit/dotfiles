{
  config,
  inputs,
  lib,
  pkgs,
  system,
  ...
}: let
  sessionTarget = "sway-session.target";
  sessionService = {
    wantedBy = [sessionTarget];
    partOf = [sessionTarget];
    after = [sessionTarget];
  };
  workspaceBinds = focus: move: suffix:
    lib.concatMapStrings (n: ''
      bindsym ${focus}${n} workspace number ${n}${suffix}
      bindsym ${move}${n} move container to workspace number ${n}${suffix}
    '') (map toString (lib.range 1 9));
in {
  imports = [inputs.cua.nixosModules.cua-driver];

  config = {
    services.cua-driver = {
      enable = true;
      package = inputs.cua.packages.${system}.cua-driver.overrideAttrs (old: {
        patches =
          (old.patches or [])
          ++ [
            ../../../patches/cua-driver-sway-null-fields.patch
            ../../../patches/cua-driver-24-bit-screencopy.patch
          ];
      });
    };

    programs.sway = {
      enable = true;
      extraOptions = ["--unsupported-gpu"];
      extraPackages = with pkgs; [fuzzel grim wl-clipboard];
      extraSessionCommands = ''
        export QT_LINUX_ACCESSIBILITY_ALWAYS_ON=1
      '';
    };

    services.greetd = {
      enable = true;
      settings.default_session = {
        command = lib.getExe config.programs.sway.package;
        user = "ominit";
      };
    };

    services.gnome.at-spi2-core.enable = true;

    environment.sessionVariables.CUA_DRIVER_RS_TELEMETRY_ENABLED = "0";

    xdg.portal.wlr.settings.screencast = {
      output_name = "HDMI-A-1";
      chooser_type = "none";
    };

    hjem.users.ominit.files.".config/sway/config" = {
      clobber = true;
      text = ''
        set $mod Mod4
        set $term ghostty
        set $menu fuzzel

        output HDMI-A-1 mode 1280x720@60Hz scale 1 position 0 0
        input type:keyboard xkb_layout us
        default_border pixel 1
        workspace_layout tabbed
        focus_on_window_activation focus

        bindsym $mod+t exec $term
        bindsym $mod+space exec $menu
        bindsym $mod+q kill
        bindsym $mod+w layout toggle tabbed split
        bindsym $mod+Shift+f fullscreen toggle
        bindsym $mod+v floating toggle
        bindsym $mod+Shift+v focus mode_toggle
        bindsym $mod+Escape seat - shortcuts_inhibitor toggle
        bindsym $mod+Shift+c reload
        bindsym $mod+Shift+e exit
        bindsym Ctrl+Alt+Delete exit

        ${lib.concatMapStrings (dir: ''
          bindsym $mod+${dir} focus ${lib.toLower dir}
          bindsym $mod+Ctrl+${dir} move ${lib.toLower dir}
        '') ["Left" "Down" "Up" "Right"]}
        bindsym $mod+Page_Down workspace next_on_output
        bindsym $mod+Page_Up workspace prev_on_output
        bindsym $mod+u workspace next_on_output
        bindsym $mod+i workspace prev_on_output
        bindsym $mod+Ctrl+Page_Down move container to workspace next_on_output
        bindsym $mod+Ctrl+Page_Up move container to workspace prev_on_output
        bindsym $mod+Ctrl+u move container to workspace next_on_output
        bindsym $mod+Ctrl+i move container to workspace prev_on_output
        ${workspaceBinds "$mod+" "$mod+Ctrl+" ""}
        mode "kvm" {
          bindsym t exec $term, mode "default"
          bindsym space exec $menu, mode "default"
          bindsym q kill, mode "default"
          bindsym w layout toggle tabbed split, mode "default"
          bindsym f fullscreen toggle, mode "default"
          bindsym v floating toggle, mode "default"
          bindsym e exit
          ${lib.concatMapStrings (dir: ''
          bindsym ${dir} focus ${lib.toLower dir}, mode "default"
        '') ["Left" "Down" "Up" "Right"]}
          ${workspaceBinds "" "Ctrl+" '', mode "default"''}
          bindsym Escape mode "default"
          bindsym Return mode "default"
        }
        bindsym Ctrl+Alt+space mode "kvm"

        exec "ln -sfn $WAYLAND_DISPLAY $XDG_RUNTIME_DIR/wayland-session && ln -sfn $SWAYSOCK $XDG_RUNTIME_DIR/sway-ipc.sock && dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP XDG_DATA_DIRS QT_LINUX_ACCESSIBILITY_ALWAYS_ON && systemctl --user restart ${sessionTarget}"
      '';
    };

    systemd.user.targets.sway-session = {
      description = "sway compositor session";
      bindsTo = ["graphical-session.target"];
      wants = ["graphical-session-pre.target"];
      after = ["graphical-session-pre.target"];
    };

    systemd.user.services.cua-driver =
      sessionService
      // {
        description = "cua-driver computer-use daemon";
        path = [
          "/etc/profiles/per-user/ominit"
          "/run/current-system/sw"
        ];
        environment = {
          CUA_DRIVER_RS_ENABLE_WAYLAND = "1";
          CUA_DRIVER_RS_TELEMETRY_ENABLED = "0";
        };
        serviceConfig = {
          ExecStart = "${lib.getExe config.services.cua-driver.package} serve";
          Restart = "on-failure";
          RestartSec = 2;
        };
      };

    systemd.user.services.helium-agent =
      sessionService
      // {
        description = "helium browser driven by agents over CDP";
        serviceConfig = {
          ExecStart = lib.concatStringsSep " " [
            (lib.getExe inputs.helium.packages.${system}.helium)
            "--user-data-dir=%h/.local/share/helium-agent"
            "--remote-debugging-port=9222"
            "--force-renderer-accessibility"
            "--ozone-platform=wayland"
            "--no-first-run"
            "--no-default-browser-check"
          ];
          Restart = "always";
          RestartSec = 2;
        };
      };
  };
}
