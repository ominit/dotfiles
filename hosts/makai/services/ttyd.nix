{...}: {
  config = {
    services.ttyd = {
      enable = true;
      clientOptions = {
        fontSize = "16";
        # fontFamily = "Fira Code";
      };
      port = 10011;
      writeable = true;
    };
  };
}
