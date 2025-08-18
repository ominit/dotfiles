{pkgs, ...}: {
  config = {
    services.ollama = {
      enable = true;
      port = 20001;
      host = "127.0.0.1";
      user = "ollama";
      home = "/data/services/ollama";
      acceleration = "cuda";
      package = pkgs.ollama.override {
        cudaArches = ["61"];
      };
    };
  };
}
