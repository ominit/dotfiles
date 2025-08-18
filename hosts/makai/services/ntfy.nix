{...}: {
  config = {
    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = "https://ntfy.42nd.net";
        listen-http = "0.0.0.0:10005";
        behind-proxy = true;
      };
    };
  };
}
