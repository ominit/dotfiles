{
  lib,
  inputs,
  pkgs,
  ...
}: {
  environment.etc."vconsole.conf".text = lib.mkForce "KEYMAP=colemak";

  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  services.scx.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh.enable = true;

  networking.networkmanager.enable = true;

  services.tzupdate.enable = true;

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

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.netbird.enable = true;

  users.users.ominit = {
    isNormalUser = true;
    description = "ominit";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.nushell;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ0KtEKf415TSy1cD+ED/33V7YTtY/I7FZjNR/FNpzXf ominit@wsl"
    ];
    packages = with pkgs; [
      inputs.zen-browser.packages."${pkgs.system}".default
      zellij
      elixir-ls
      libreoffice
      slack
      sbcl
      signal-desktop
      xfce.thunar
      zenity
      bitwarden
      tutanota-desktop
      cava
      feishin
      feh
      vesktop
      obsidian
      ffmpeg
      mpv
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
      waybar

      swww
      hyprlock
      hypridle
      rofi-wayland
      hyprpolkitagent
      hyprpicker
      clipse
      wl-clipboard
      waypaper
      brightnessctl
      playerctl
      pamixer
      wlogout
    ];
  };

  fonts.packages = [] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.gnome.gnome-keyring.enable = true;

  services.gvfs.enable = true;
  services.upower.enable = true;
  services.thermald.enable = true;
  services.system76-scheduler.enable = true;
  # programs.auto-cpufreq.enable = true;
  # programs.auto-cpufreq.settings = {
  #   charger = {
  #     governor = "performance";
  #     turbo = "auto";
  #   };
  #   battery = {
  #     governer = "powersave";
  #     turbo = "never";
  #   };
  # };

  services.displayManager.ly.enable = true;
}
