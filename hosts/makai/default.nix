{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    ./disko.nix
    ./hardware.nix
    inputs.disko.nixosModules.default
    inputs.sops-nix.nixosModules.sops
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
    };

    # don't allow mutation of users outside of the config
    users.mutableUsers = false;

    sops.secrets."makai/hashedPassword".neededForUsers = true;

    users.users."ominit" = {
      isNormalUser = true;
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.nushell;
      openssh.authorizedKeys.keys = [
        "SHA256:UfCktWqDzCtukQTZ6IPIO+yV7kte91DadCZeftU8xRE ominit@wsl"
      ];
      hashedPasswordFile = config.sops.secrets."makai/hashedPassword".path;
    };

    services.openssh.enable = true;
    networking.wireless.enable = true;
    services.netbird.enable = true;

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
