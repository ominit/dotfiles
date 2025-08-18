{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    ./disko.nix
    ./services
    inputs.disko.nixosModules.default
    inputs.nixos-facter-modules.nixosModules.facter
    {config.facter.reportPath = ./facter.json;}
  ];

  config = {
    modules.programs = {
      helix = {
        enable = true;
        package = pkgs.helix_git; # from chaotic (cached)
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
      shell = pkgs.nushell;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ0KtEKf415TSy1cD+ED/33V7YTtY/I7FZjNR/FNpzXf ominit@wsl"
      ];
      hashedPasswordFile = config.sops.secrets."hashedPassword".path;
      packages = with pkgs; [
        nh
      ];
    };

    systemd.tmpfiles.rules = [
      "d /data/dotfiles 2700 ${config.users.users.ominit.name} ${config.users.users.ominit.group} -"
      "d /data/system/ssh 0750 root root -"
    ];

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

    services.tzupdate.enable = true;

    virtualisation.podman.enable = true;
    virtualisation.podman.autoPrune = {
      enable = true;
      dates = "monthly";
    };

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    nix.optimise = {
      automatic = true;
    };

    nix.gc = {
      automatic = true;
      options = "--delete-older-than 30d";
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
