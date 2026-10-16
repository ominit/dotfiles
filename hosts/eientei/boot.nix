{
  lib,
  pkgs,
  ...
}: {
  environment.etc."vconsole.conf".text = lib.mkForce "KEYMAP=colemak";

  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  services.scx.enable = true;
  services.scx.scheduler = "scx_bpfland";

  services.fwupd.enable = true;

  zramSwap.enable = true;
  systemd.oomd.enableUserSlices = true;
  boot.kernelParams = ["zswap.enabled=0" "nowatchdog"];
  boot.kernelModules = ["tcp_bbr"];
  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
    "vm.page-cluster" = 0;
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };
}
