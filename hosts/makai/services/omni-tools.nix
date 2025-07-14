{
  config = {
    virtualisation.oci-containers.containers.omni-tools = {
      image = "iib0011/omni-tools:latest";
      ports = [
        "127.0.0.1:10004:80"
      ];
      autoStart = true;
    };
  };
}
