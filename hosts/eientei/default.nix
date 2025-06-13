{pkgs, ...}: {
  imports = [
    ./hardware.nix
  ];

  config = {
    # TODO need to setup correctly
    # boot.kernelPackages = pkgs.linuxPackages_cachyos;
    # services.scx.enable = true;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    users.users."ominit" = {
      isNormalUser = true;
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.nushell;
    };

    system.stateVersion = "25.05";
  };
}
