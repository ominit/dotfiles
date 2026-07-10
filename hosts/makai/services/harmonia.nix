{...}: {
  config = {
    services.harmonia = {
      cache = {
        enable = true;
        signKeyPaths = ["/data/system/key.secret"];
        settings = {
          bind = "127.0.0.1:10013";
          enable_compression = true;
        };
      };
    };
  };
}
