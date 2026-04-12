{...}: {
  services.openssh.enable = true;
  services.tzupdate.enable = true;
  services.netbird.enable = true;

  networking.networkmanager.enable = true;
}
