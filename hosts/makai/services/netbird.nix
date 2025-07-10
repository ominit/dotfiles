{...}: {
  config = {
    services.netbird = {
      enable = true;
    };
    fileSystems."/var/lib/netbird" = {
      device = "/data/services/netbird";
      options = ["bind"];
    };

    networking.firewall.allowedUDPPorts = [53];
  };
}
