{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    ./disko.nix
    ./hardware.nix
    ./services
    inputs.disko.nixosModules.default
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
      nushell.enable = true;
      btop.enable = true;
      yazi.enable = true;
    };

    environment.variables = {
      EDITOR = "hx";
      NH_FLAKE = "/data/dotfiles";
    };

    # don't allow mutation of users outside of the config
    users.mutableUsers = false;

    sops.defaultSopsFile = ./../../secrets/makai.yaml;
    sops.secrets."hashedPassword".neededForUsers = true;

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

    services.grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = 3000;
          root_url = "https://192.168.50.169";
          domain = "192.168.50.169";
        };
      };
    };

    services.caddy = {
      enable = true;

      virtualHosts = {
        "192.168.50.169" = {
          extraConfig = ''
            reverse_proxy http://${config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}
            tls internal
          '';
        };
      };
    };

    networking.firewall.allowedTCPPorts = [80 443 3000];

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
