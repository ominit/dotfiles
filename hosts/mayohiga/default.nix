{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports =
    [
      ./disko.nix
      {hardware.facter.reportPath = ./facter.json;}
      inputs.disko.nixosModules.default
    ]
    ++ (inputs.self.lib.filesIn ./services);

  config = {
    modules.programs = {
      helix = {
        enable = true;
        package = pkgs.helix_git;
      };
      bat.enable = true;
      jujutsu.enable = true;
      zellij.enable = true;
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
    };

    environment.systemPackages = [pkgs.ghostty.terminfo];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_cachyos-server;

    services.scx-loader.enable = true;
    services.scx-loader.config.default_sched = "scx_bpfland";

    fileSystems."/data".neededForBoot = true;

    modules.persistence.directories.journal = {
      source = "/data/system/journal";
      target = "/var/log/journal";
    };
    # journald must start writing to disk after the journal bind mount exists
    systemd.services.systemd-journal-flush.after = ["persistence-bind-mounts.service"];

    services.openssh = {
      enable = true;
      hostKeys = [
        {
          type = "ed25519";
          path = "/data/system/ssh/ssh_host_ed25519_key";
        }
      ];
    };

    sops.defaultSopsFile = ./../../secrets/mayohiga.yaml;
    sops.secrets."hashedPassword".neededForUsers = true;

    users.mutableUsers = false;
    users.users."ominit" = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      shell = config.modules.programs.nushell.package;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ0KtEKf415TSy1cD+ED/33V7YTtY/I7FZjNR/FNpzXf ominit@wsl"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK1Vj5MoiiaBQzdEEXGP6zVQbszLDLHKKVB1E5SZWETg ominit@eientei"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKoQZP933Mc12GwEoUiOt+LZ4b+/5+Bq/T0lSryEXAu9 ominit@makai"
      ];
      hashedPasswordFile = config.sops.secrets."hashedPassword".path;
      packages = with pkgs; [
        nh
        ripgrep
        jq
        gh
      ];
    };

    systemd.tmpfiles.rules = [
      "d /data/dotfiles 2700 ${config.users.users.ominit.name} ${config.users.users.ominit.group} -"
      "d /data/system/ssh 0750 root root -"
      "d /home/ominit/.cache - ominit users -"
      "d /home/ominit/.ssh - ominit users -"
      "d /home/ominit/.config/nushell - ominit users -"
      "d /home/ominit/.config/ - ominit users -"
    ];

    modules.persistence.directories.ominit-home = {
      source = "/data/home/ominit";
      target = "/home/ominit";
      user = "ominit";
      group = "users";
      mode = "0700";
    };

    nix.settings = {
      trusted-users = ["root" "ominit"];
      keep-outputs = true;
    };
    nix.channel.enable = false;

    boot.binfmt.emulatedSystems = ["aarch64-linux"];

    zramSwap.enable = true;
    systemd.oomd.enableSystemSlice = true;
    boot.kernelParams = ["zswap.enabled=0"];
    boot.kernelModules = ["tcp_bbr"];
    boot.kernel.sysctl = {
      "vm.swappiness" = 180;
      "vm.page-cluster" = 0;
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };

    systemd.services.nix-daemon.serviceConfig = {
      CPUWeight = 25;
      Nice = 10;
    };
    nix.daemonCPUSchedPolicy = "batch";
    nix.daemonIOSchedClass = "idle";

    nix.optimise = {
      automatic = true;
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 21d";
    };

    # when less than 30GB
    # free until 150GB free
    nix.extraOptions = ''
      min-free = ${toString (30 * 1024 * 1024 * 1024)}
      max-free = ${toString (150 * 1024 * 1024 * 1024)}
    '';

    system.stateVersion = "26.11";
  };
}
