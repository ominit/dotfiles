{...}: {
  config = {
    virtualisation.oci-containers.containers.feishin = {
      image = "ghcr.io/jeffvli/feishin:latest";
      ports = [
        "127.0.0.1:10002:9180"
      ];
      environment = {
        PUBLIC_PATH = "/feishin";
        SERVER_NAME = "makai";
        SERVER_TYPE = "subsonic";
        SERVER_URL = "https://makai.ominit.io/gonic";
        SERVER_LOCK = "true";
        TZ = "America/Los_Angeles";
      };
      autoStart = true;
    };
  };
}
