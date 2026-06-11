{...}: {
  config = {
    services.netbird = {
      enable = true;
      clients.default.hardened = true;
    };
    modules.persistence.bindMounts.netbird = {
      source = "/data/services/netbird";
      target = "/var/lib/netbird";
      user = "netbird";
      group = "netbird";
      mode = "0700";
      resetPermissions = true;
    };

    networking.firewall.allowedUDPPorts = [53];
  };
}
