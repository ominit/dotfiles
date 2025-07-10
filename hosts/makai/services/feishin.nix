{config, ...}: {
  config = {
    virtualization.oci-containers.containers.feishin = {
      image = "ghcr.io/jeffvli/feishin:latest";
      ports = [
        "127.0.0.1:10002:10002"
      ];
      environment = {
        PUBLIC_PATH = "/feishin";
        SERVER_NAME = "makai";
        SERVER_TYPE = "subsonic";
        SERVER_URL = "http://${builtins.head config.services.gonic.settings.listen-addr}";
        SERVER_LOCK = "true";
        TZ = "America/Los_Angeles";
      };
      autoStart = true;
      restart = "unless-stopped";
    };
  };
}
