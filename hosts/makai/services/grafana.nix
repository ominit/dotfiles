{...}: {
  config = {
    services.grafana = {
      enable = true;
      dataDir = "/data/services/grafana";
      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = 10000;
          root_url = "https://makai.ominit.io/grafana/";
          domain = "makai.ominit.io";
          serve_from_sub_path = true;
        };
      };
    };
  };
}
