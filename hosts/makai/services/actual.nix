{ ...}: {
  config = {
    services.actual = {
      enable = true;
      user = "actual";
      group = "actual";
      settings = {
        port = 10003;
      };
    };

    modules.persistence.bindMounts.actual = {
      source = "/data/services/actual";
      target = "/var/lib/actual";
      user = "actual";
      group = "actual";
      mode = "0700";
      resetPermissions = true;
    };

    users.users.actual = {
      isSystemUser = true;
      group = "actual";
    };

    users.groups.actual = {};
  };
}
