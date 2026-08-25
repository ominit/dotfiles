{...}: {
  services.openssh.enable = true;
  # services.tzupdate.enable = true;
  time.timeZone = "America/New_York";
  services.netbird.enable = true;

  networking.networkmanager.enable = true;
  networking.dhcpcd.enable = false; # conflicts with network manager, it is enabled through nixos-facter.
}
