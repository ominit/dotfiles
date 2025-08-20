{...}: {
  config = {
    services.actual = {
      enable = true;
      settings = {
        port = 10003;
      };
    };

    fileSystems."/var/lib/private/actual" = {
      device = "/data/services/actual";
      options = ["bind"];
    };
  };
}
