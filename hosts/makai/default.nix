{
  pkgs,
  inputs,
  config,
  system,
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
    modules.programs = {
      helix = {
        enable = true;
        package = inputs.helix.packages.${system}.default;
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

    networking.firewall.enable = true;

    # don't allow mutation of users outside of the config
    users.mutableUsers = false;

    sops.defaultSopsFile = ./../../secrets/makai.yaml;
    sops.secrets."hashedPassword".neededForUsers = true;

    nix.settings.trusted-users = ["root" "ominit"];

    users.users."ominit" = {
      isNormalUser = true;
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
      ];
    };

    sops.secrets."sshKey" = {
      path = "/home/ominit/.ssh/id_ed25519";
      owner = "ominit";
      group = "users";
      mode = "0400";
    };

    systemd.tmpfiles.rules = [
      "d /data/dotfiles 2700 ${config.users.users.ominit.name} ${config.users.users.ominit.group} -"
      "d /data/system/ssh 0750 root root -"
      "d /home/ominit/.cache 0755 ominit users -"
    ];

    modules.persistence.bindMounts.codex = {
      source = "/data/home/ominit/.codex";
      target = "/home/ominit/.codex";
      user = "ominit";
      group = "users";
    };

    modules.persistence.bindMounts.nix-cache = {
      source = "/data/home/ominit/.cache/nix";
      target = "/home/ominit/.cache/nix";
      user = "ominit";
      group = "users";
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

    nixpkgs.config.cudaSupport = true;
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
    boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-server;
    boot.binfmt.emulatedSystems = ["aarch64-linux"];

    services.scx.enable = true;
    services.scx.scheduler = "scx_bpfland";

    nix.optimise = {
      automatic = true;
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
