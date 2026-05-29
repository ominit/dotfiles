{...}: {
  config = {
    virtualisation.oci-containers.containers.termix = {
      # image = "ghcr.io/lukegus/termix:latest";
      image = "ghcr.io/lukegus/termix:release-2.3.1";
      pull = "newer";
      ports = [
        "10008:10008"
      ];
      extraOptions = ["--network=host"];
      environment = {
        PORT = "10008";
      };
      autoStart = true;
      volumes = [
        "/data/services/termix:/app/data"
      ];
    };
  };
}
