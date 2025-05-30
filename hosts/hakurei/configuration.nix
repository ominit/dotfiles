{
  inputs,
  config,
  pkgs,
  nixpkgs,
  lib,
  outputs,
  disko,
  ...
}: {
  imports = [
    # ./hardware-configuration.nix
    # ./disko.nix
    # disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.chaotic.nixosModules.default
    inputs.auto-cpufreq.nixosModules.default
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    outputs.programModules.default
  ];

  nixpkgs.hostPlatform = {system = "aarch64-linux";};
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  myPrograms = {
    yazi.enable = true;
    btop.enable = true;
    bat.enable = true;
    git.enable = true;
    # helix.enable = true;
    nushell.enable = true;
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    users.ominit = import ./home.nix;
    backupFileExtension = "backup";
  };

  nixpkgs.overlays = [
    inputs.nur.overlays.default
  ];

  environment.etc."vconsole.conf".text = lib.mkForce "KEYMAP=colemak";

  # cachyos kernel is goated
  # boot.kernelPackages = pkgs.linuxPackages_cachyos;
  # services.scx.enable = true;

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "hakurei";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  services.openssh.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.netbird.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ominit = {
    isNormalUser = true;
    description = "ominit";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.nushell;
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK1Vj5MoiiaBQzdEEXGP6zVQbszLDLHKKVB1E5SZWETg ominit@eientei"];
    packages = with pkgs; [
      zenity
      delta
      ffmpeg
      mpv
      ffmpegthumbnailer
      jq
      fd
      fzf
      zoxide
      imagemagick
      poppler
      autorandr
      fastfetch
      pavucontrol
      networkmanager
      networkmanagerapplet
      bluez
      bluez-tools
      blueman
      udiskie
      trash-cli
      pciutils
      lm_sensors
      grimblast
      slurp
      swappy
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    lshw
    wget
    lldb
    pkg-config
    openssl
    gcc
  ];

  fonts.packages = [] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.gnome.gnome-keyring.enable = true;

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
