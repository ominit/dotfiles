{...}: {
  services.openssh.enable = true;
  # services.tzupdate.enable = true;
  time.timeZone = "America/New_York";
  services.netbird.enable = true;

  networking.networkmanager.enable = true;
}
