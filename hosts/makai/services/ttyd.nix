{config, ...}: {
  config = {
    services.ttyd = {
      enable = true;
      clientOptions = {
        fontSize = "16";
      };
      port = 10011;
      interface = "lo";
      writeable = true;
    };

    modules.pangolin.resources.peppery-eastern-hognose-snake = {
      name = "ttyd";
      domain = "ttyd.42nd.net";
      inherit (config.services.ttyd) port;
    };
  };
}
