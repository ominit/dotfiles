{...}: {
  services.gonic = {
    enable = true;
    settings = {
      db-path = "file:///data/services/gonic/gonic.db";
      music-path = "/data/storage/gonic/music";
      playlists-path = "/data/storage/gonic/playlists";
      podcasts-path = "/data/storage/gonic/podcasts";
      cache-path = "/data/services/gonic/cache";
      http-log = "/data/services/gonic/logs";
      listen-addr = "127.0.0.1:10001";
      scan-interval = "1445";
      scan-at-start-enabled = "true";
      multi-value-genre = "multi";
      multi-value-artist = "multi";
      multi-value-album-artist = "multi";
    };
  };
}
