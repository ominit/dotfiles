{
  config = {
    virtualisation.oci-containers.containers.omni-tools = {
      image = "iib0011/omni-tools:latest";
      pull = "newer";
      ports = [
        "10004:80"
      ];
      autoStart = true;
    };
  };
}
