{
  inputs,
  config,
  pkgs,
  lib,
  outputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.chaotic.nixosModules.default
    inputs.auto-cpufreq.nixosModules.default
    outputs.programModules.default
  ];

  myPrograms = {
    hyprland.enable = true;
    # yazi.enable = true;
    # btop.enable = true;
    # bat.enable = true;
    git.enable = true;
    helix.enable = true;
    # librewolf.enable = true;
    nushell.enable = true;
    wezterm.enable = true;
    ly.enable = true;
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    users.ominit = import ./home.nix;
  };

  nixpkgs.overlays = [
    inputs.hyprpanel.overlay
    # inputs.rust-overlay.overlays.default
  ];

  environment.etc."vconsole.conf".text = lib.mkForce "KEYMAP=colemak";

  # latest kernel required for asus laptop + cachyos kernel is goated
  # boot.kernelPackages = pkgs.linuxPackages_cachyos;
  # chaotic.scx.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "desktop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";
  # services.automatic-timezoned.enable = true;

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

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  # services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb = {
  #   layout = "us";
  #   variant = "colemak";
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.netbird.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ominit = {
    isNormalUser = true;
    description = "ominit";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.nushell;
    packages = with pkgs; [
      hyprpanel
      feishin
      vesktop
      ffmpeg
      mpv
      lutris
      ffmpegthumbnailer
      gimp
      jq
      fd
      fzf
      zoxide
      imagemagick
      poppler
      autorandr
      wayland
      egl-wayland
      xwayland
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
      # inputs.discidium.packages."${pkgs.system}".default
    ];
  };
  programs.steam.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # power-profiles-daemon
    lshw
    wget
    # brave
    netbird-ui
    # pkgs.rust-bin.stable.latest.default
    # rust-analyzer
    # lldb
    # pkg-config
    # openssl
    # gcc
  ];

  fonts.packages = [] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.gnome.gnome-keyring.enable = true;

  # nvidia
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
    # prime = {
    #   intelBusId = "PCI:0:2:0";
    #   nvidiaBusId = "PCI:1:0:0";

    #   offload = {
    #     enable = true;
    #     enableOffloadCmd = true;
    #   };

    # reverseSync.enable = lib.mkDefault true;
    # };
    modesetting.enable = true;
    # powerManagement.enable = true;
    # powerManagement.finegrained = true;
    # open = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
