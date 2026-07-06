{...}: {
  config = {
    virtualisation.oci-containers.containers.termix = {
      # image = "ghcr.io/lukegus/termix:latest";
      image = "ghcr.io/lukegus/termix:release-2.5.0";
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

    systemd.services.podman-termix = {
      after = ["netbird.service"];
      wants = ["netbird.service"];
    };
  };
}
