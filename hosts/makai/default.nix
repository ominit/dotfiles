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

    sops.age.keyFile = "/data/sops/keys";
    sops.secrets."makai/hashedPassword".neededForUsers = true;

    users.users."ominit" = {
      isNormalUser = true;
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.nushell;
      openssh.authorizedKeys.keys = [
      ];
      hashedPasswordFile = config.sops.secrets."makai/hashedPassword".path;
    };

    systemd.tmpfiles.rules = [
      "d /data/dotfiles 2700 ominit ominit -"
    ];

    services.openssh.enable = true;
    # TODO need to setup
    # networking.wireless.enable = true;
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
