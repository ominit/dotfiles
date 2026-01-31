{
  inputs,
  system,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
    inputs.nixos-facter-modules.nixosModules.facter
    inputs.clavium-explico.nixosModules.evdevLoggerModule
    {config.facter.reportPath = ./facter.json;}
    ./temp.nix
  ];

  config = {
    modules.programs = {
      helix = {
        enable = true;
        # package = pkgs.helix_git; # from chaotic (cached)
        package = inputs.helix.packages.${system}.default;
      };
      bat.enable = true;
      git = {
        enable = true;
        deltaPager = true;
      };
      nushell = {
        enable = true;
        extraSources = [./env-vars.nu];
      };
      btop.enable = true;
      yazi.enable = true;
      ghostty.enable = true;
      niri = {
        enable = true;
        package = inputs.niri.packages.${system}.default;
      };
      rofi.enable = true;
      quickshell = {
        enable = true;
        package =
          inputs.quickshell.packages.${system}.default;
      };
      jujutsu.enable = true;
      # jujutsu.package = inputs.jujutsu.packages.${system}.default;
      zellij.enable = true;
    };

    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        glib
        nspr
        nss
        dbus
        atk
        cups
        cairo
        gtk3
        pango
        xorg.libX11
        xorg.libXcomposite
        xorg.libXdamage
        xorg.libXext
        xorg.libXfixes
        xorg.libXrandr
        libgbm
        expat
        xorg.libxcb
        libxkbcommon
        alsa-lib
        libglvnd
      ];
    };

    services.ce-evdev-logger = {
      enable = true;
      extraAnalysisUsers = ["ominit"];
      dbPath = "/var/lib/ce-evdev-logger/keys.db";
      kbLayout = "us";
      kbOptions = "caps:backspace";
      kbVariant = "colemak";
    };

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/7f0b7f5c-760c-438f-abfa-dc24171f61f2";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/D371-B32E";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };

    swapDevices = [
      {device = "/dev/disk/by-uuid/3f692953-8afd-464a-9cff-03d0b7bb7866";}
    ];

    nix.settings.trusted-users = ["root" "ominit"];

    services.resolved.enable = true;

    systemd.user.units."app-org.fcitx.Fcitx5@autostart.service".enable = false;
    i18n.inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          qt6Packages.fcitx5-chinese-addons
          fcitx5-rime
          fcitx5-lua
          fcitx5-mozc
          fcitx5-gtk
          fcitx5-rose-pine
          fcitx5-tokyonight
          kdePackages.fcitx5-qt
        ];
      };
    };

    i18n.supportedLocales = ["zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8"];

    services.syncthing = {
      enable = true;
      user = "ominit";
      group = "users";
      dataDir = "/home/ominit/sync";
      settings = {
        devices = {
          "win11" = {id = "PDG7QZA-YPB5TEZ-GT7L3YF-MJPS6XI-YDGWK6T-7EILW4O-PHOMCOS-J5T4NAB";};
        };
        folders = {
          "obsidian-notes" = {
            "path" = "/home/ominit/sync/obsidian-notes";
            devices = ["win11"];
          };
        };
      };
    };

    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder

    nix.optimise = {
      automatic = true;
    };

    # nix.gc = {
    #   automatic = true;
    #   options = "--delete-older-than 30d";
    # };

    # # when less than 10GB
    # # free until 30GB free
    # nix.extraOptions = ''
    #   min-free = ${toString (10 * 1024 * 1024 * 1024)}
    #   max-free = ${toString (30 * 1024 * 1024 * 1024)}
    # '';

    system.stateVersion = "24.05";
  };
}
