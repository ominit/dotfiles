{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  config = {
    modules.programs = {
      helix = {
        enable = true;
        # package = inputs.helix.packages."${pkgs.system}".helix; # helix git (not cached)
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
    };

    wsl.enable = true;
    wsl.defaultUser = "ominit";

    boot.binfmt.emulatedSystems = ["aarch64-linux"];
    wsl.interop.register = true;

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
