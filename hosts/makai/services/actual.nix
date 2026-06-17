{...}: {
  config = {
    services.actual = {
      enable = true;
      user = "actual";
      group = "actual";
      settings = {
        port = 10003;
      };
    };

    modules.persistence.directories.actual = {
      source = "/data/services/actual";
      target = "/var/lib/actual";
      user = "actual";
      group = "actual";
      resetPermissions = true;
    };

    users.users.actual = {
      isSystemUser = true;
      group = "actual";
    };

    users.groups.actual = {};
  };
}
