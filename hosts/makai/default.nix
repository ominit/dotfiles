{
  pkgs,
  inputs,
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

    users.users."ominit" = {
      isNormalUser = true;
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.nushell;
	  openssh.authorizedKeys.keys = [
		"SHA256:UfCktWqDzCtukQTZ6IPIO+yV7kte91DadCZeftU8xRE ominit@wsl"
	  ];
    };

	services.openssh.enable = true;

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
