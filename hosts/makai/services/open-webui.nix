{
  inputs,
  system,
  ...
}: {
  config = {
    services.open-webui = {
      enable = true;
      # wont compile otherwise, i assume cuda messes with it.
      package =
        (import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }).open-webui;
      host = "0.0.0.0";
      environment = {
        OLLAMA_BASE_URL = "http://localhost:20001";
        ENABLE_SIGNUP_PASSWORD_CONFIRMATION = "true";
        ENV = "dev";
      };
      port = 10007;
    };

    fileSystems."/var/lib/private/open-webui" = {
      device = "/data/services/open-webui";
      options = ["bind"];
    };
  };
}
