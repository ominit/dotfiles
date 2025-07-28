{...}: {
  config = {
    services.grafana = {
      enable = true;
      dataDir = "/data/services/grafana";
      settings = {
        server = {
          http_addr = "0.0.0.0";
          http_port = 10000;
          root_url = "https://grafana.42nd.net/";
          domain = "grafana.42nd.net";
        };
      };
    };
  };
}
