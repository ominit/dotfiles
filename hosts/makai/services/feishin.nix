{...}: {
  config = {
    virtualisation.oci-containers.containers.feishin = {
      image = "ghcr.io/jeffvli/feishin:latest";
      pull = "newer";
      ports = [
        "10002:9180"
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
  };
}
