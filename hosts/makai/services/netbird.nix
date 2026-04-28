{...}: {
  config = {
    services.netbird = {
      enable = true;
    };
    fileSystems."/var/lib/netbird" = {
      device = "/data/services/netbird";
      fsType = "none";
      options = ["bind"];
    };

    networking.firewall.allowedUDPPorts = [53];
  };
}
