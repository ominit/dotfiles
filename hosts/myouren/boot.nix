{
  lib,
  pkgs,
  ...
}: {
  environment.etc."vconsole.conf".text = lib.mkForce "KEYMAP=colemak";

  # boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.binfmt.emulatedSystems = ["aarch64-linux"];

  # services.scx.enable = true;
  # services.scx.scheduler = "scx_bpfland";
}
