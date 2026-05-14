
{...}: {
  config = {
    virtualisation.oci-containers.containers.termix = {
      image = "ghcr.io/lukegus/termix:latest";
      pull = "newer";
      ports = [
        "10008:8080"
      ];
      environment = {
        PORT = "8080";
      };
      autoStart = true;
      volumes = [
        "/data/services/termix:/app/data"
      ];
    };
  };
}
