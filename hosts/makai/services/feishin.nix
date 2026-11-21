{...}: {
  config = {
    virtualisation.oci-containers.containers.feishin = {
      image = "ghcr.io/jeffvli/feishin:latest";
      pull = "newer";
      ports = [
        "127.0.0.1:10002:9180"
      ];
      environment = {
        SERVER_NAME = "LMS";
        SERVER_TYPE = "subsonic";
        SERVER_URL = "https://feishin.42nd.net";
        SERVER_LOCK = "true";
        TZ = "America/Los_Angeles";
      };
      autoStart = true;
    };

    modules.pangolin.resources.right-porcellio-scaber = {
      name = "feishin";
      domain = "feishin.42nd.net";
      port = 10002;
      healthInterval = 30;
      extraTargets = [
        {
          method = "http";
          hostname = "localhost";
          port = 10001;
          enabled = true;
          path = "/rest";
          path-match = "prefix";
          priority = 110;
        }
      ];
    };
  };
}
