{...}: {
  config = {
    services.gonic = {
      enable = true;
      settings = {
        # db-path = "/data/services/gonic/gonic.db";
        music-path = "/data/storage/gonic/music";
        playlists-path = "/data/storage/gonic/playlists";
        podcast-path = "/data/storage/gonic/podcasts";
        listen-addr = "127.0.0.1:10001";
        proxy-prefix = "gonic";
        scan-interval = 1445;
        scan-at-start-enabled = true;
        multi-value-genre = "delim /";
        multi-value-artist = "delim /";
        multi-value-album-artist = "delim /";
      };
    };

    systemd.services.gonic = {
      serviceConfig = {
        User = "gonic";
        Group = "gonic";
      };
    };

    users.users.gonic = {
      isSystemUser = true;
      group = "gonic";
    };

    users.groups.gonic = {};
  };
}