{...}: {
  config = {
    services.netbird = {
      enable = true;
    };

    modules.persistence.bindMounts.netbird = {
      source = "/data/services/netbird";
      target = "/var/lib/netbird";
      user = "netbird";
      group = "netbird";
      mode = "0700";
      resetPermissions = true;
    };

    systemd.services.netbird.serviceConfig = {
      User = "netbird";
      Group = "netbird";
      AmbientCapabilities = [
        "CAP_NET_ADMIN"
        "CAP_NET_RAW"
        "CAP_NET_BIND_SERVICE"
        "CAP_BPF"
      ];
    };

    users.users.netbird = {
      isSystemUser = true;
      group = "netbird";
    };

    users.groups.netbird = {};

    networking.firewall.allowedUDPPorts = [53];
  };
}
