{...}: {
  config = {
    services.ttyd = {
      enable = true;
      clientOptions = {
        fontSize = "16";
      };
      port = 10011;
      interface = "lo";
      writeable = true;
    };
  };
}
