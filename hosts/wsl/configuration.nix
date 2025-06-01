{
  inputs,
  pkgs,
  lib,
  outputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.default
    outputs.programModules.default
    inputs.nixos-wsl.nixosModules.default
  ];

  myPrograms = {
    # zed.enable = true;
    # yazelix.enable = true;
    # jujutsu.enable = true;
    yazi.enable = true;
    btop.enable = true;
    bat.enable = true;
    git.enable = true;
    helix.enable = true;
    nushell.enable = true;
  };

  boot.binfmt.emulatedSystems = ["aarch64-linux"];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  wsl.enable = true;
  wsl.defaultUser = "ominit";

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

  networking.hostName = "wsl"; # Define your hostname.

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ominit = {
    isNormalUser = true;
    description = "ominit";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.nushell;
    packages = with pkgs; [
      zellij
      elixir-ls
      sbcl
      elixir
      delta
      ffmpeg
      mpv
      ffmpegthumbnailer
      jq
      fd
      fzf
      zoxide
      poppler
      autorandr
      fastfetch
      pavucontrol
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    lshw
    wget
    rust-analyzer
    lldb
    pkg-config
    openssl
    gcc
  ];

  fonts.packages = [] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
