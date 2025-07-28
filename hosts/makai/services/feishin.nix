{...}: {
  config = {
    virtualisation.oci-containers.containers.feishin = {
      image = "ghcr.io/jeffvli/feishin:latest";
      ports = [
        "10002:9180"
      ];
      environment = {
        SERVER_NAME = "gonic";
        SERVER_TYPE = "subsonic";
        SERVER_URL = "https://gonic.42nd.net";
        SERVER_LOCK = "true";
        TZ = "America/Los_Angeles";
      };
      autoStart = true;
    };
  };
}
