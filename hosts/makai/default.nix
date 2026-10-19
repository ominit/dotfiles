{
  pkgs,
  inputs,
  config,
  multiverse,
  ...
}: {
  imports =
    [
      ./disko.nix
      inputs.disko.nixosModules.default
      {hardware.facter.reportPath = ./facter.json;}
    ]
    ++ (inputs.self.lib.filesIn ./services);

  config = {
    modules = {
      agents.harnesses = [
        {
          name = "kraai";
          agentFiles = [../../modules/agents/AGENTS.md ./AGENTS.md ../../modules/agents/skills/unslop/SKILL.md];
        }
        {
          name = "codex";
          package = multiverse.latest.codex;
          mcpServers = ["notion" "cua-driver" "chrome-devtools"];
          agentFiles = [../../modules/agents/AGENTS.md ./AGENTS.md ../../modules/agents/skills/unslop/SKILL.md];
        }
        {
          name = "claude-code";
          package = multiverse.latest.claude-code;
          mcpServers = ["notion" "cua-driver" "chrome-devtools"];
          settings.attribution = {
            commit = "";
            pr = "";
          };
          agentFiles = [../../modules/agents/AGENTS.md ./AGENTS.md ../../modules/agents/skills/unslop/SKILL.md];
        }
        {
          name = "opencode";
          package = multiverse.latest.opencode;
          mcpServers = ["notion" "cua-driver" "chrome-devtools"];
          agentFiles = [../../modules/agents/AGENTS.md ./AGENTS.md ../../modules/agents/skills/unslop/SKILL.md];
        }
      ];

      programs = {
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
        ghostty = {
          enable = true;
          package = pkgs.ghostty_git;
        };
      };
    };

    environment.systemPackages = [pkgs.ghostty.terminfo];

    networking.firewall.enable = true;

    # don't allow mutation of users outside of the config
    users.mutableUsers = false;

    sops.defaultSopsFile = ./../../secrets/makai.yaml;
    sops.secrets."hashedPassword".neededForUsers = true;

    nix.settings = {
      trusted-users = ["root" "ominit"];
      max-jobs = 3;
      cores = 2;
    };
    nix.channel.enable = false;

    users.users."ominit" = {
      isNormalUser = true;
      subUidRanges = [
        {
          startUid = 100000;
          count = 262144;
        }
      ];
      subGidRanges = [
        {
          startGid = 100000;
          count = 262144;
        }
      ];
      extraGroups = ["networkmanager" "wheel"];
      shell = config.modules.programs.nushell.package;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ0KtEKf415TSy1cD+ED/33V7YTtY/I7FZjNR/FNpzXf ominit@wsl"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK1Vj5MoiiaBQzdEEXGP6zVQbszLDLHKKVB1E5SZWETg ominit@eientei"
      ];
      hashedPasswordFile = config.sops.secrets."hashedPassword".path;
      packages = with pkgs; [
        nh
        ripgrep
        jq
        gh
      ];
    };

    sops.secrets."sshKey" = {
      path = "/data/home/ominit/.ssh/id_ed25519";
      owner = "ominit";
      group = "users";
      mode = "0400";
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

    fileSystems."/data".neededForBoot = true;

    services.openssh = {
      enable = true;
      hostKeys = [
        {
          type = "ed25519";
          path = "/data/system/ssh/ssh_host_ed25519_key";
        }
      ];
    };
    # TODO need to setup
    # networking.wireless.enable = true;

    hardware.nvidia = {
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
    };
    hardware.nvidia-container-toolkit.enable = true;
    services.xserver.videoDrivers = ["nvidia"];
    hardware.graphics.enable = true;
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_580;

    services.tzupdate.enable = true;

    virtualisation.podman.enable = true;
    virtualisation.podman.autoPrune = {
      enable = true;
      dates = "monthly";
    };

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_cachyos-server;
    boot.binfmt.emulatedSystems = ["aarch64-linux"];

    services.scx.enable = true;
    services.scx.scheduler = "scx_bpfland";

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

    fonts.packages = with pkgs;
      [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
      ]
      ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

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

    # when less than 10GB
    # free until 30GB free
    nix.extraOptions = ''
      min-free = ${toString (10 * 1024 * 1024 * 1024)}
      max-free = ${toString (30 * 1024 * 1024 * 1024)}
    '';

    system.stateVersion = "25.05";
  };
}
