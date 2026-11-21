{...}: {
  config = {
    services.harmonia = {
      cache = {
        enable = true;
        signKeyPaths = ["/data/system/key.secret"];
        settings = {
          bind = "127.0.0.1:10002";
          enable_compression = true;
        };
      };
    };

    modules.pangolin.resources.far-flung-texas-leafcutter-ant = {
      name = "harmonia";
      domain = "harmonia.42nd.net";
      port = 10002;
      sso = false;
      healthPath = "/health";
    };
  };
}
