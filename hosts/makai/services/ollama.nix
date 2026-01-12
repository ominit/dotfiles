{pkgs, ...}: {
  config = {
    services.ollama = {
      enable = true;
      port = 20001;
      host = "127.0.0.1";
      user = "ollama";
      home = "/data/services/ollama";
      package = pkgs.ollama-cuda.override {
        cudaArches = ["61"];
      };
    };

    systemd.tmpfiles.rules = [
      "d /data/services/ollama 0755 ollama ollama -"
      "Z /data/services/ollama 0755 ollama ollama -"
    ];
  };
}
