{...}: {
  config = {
    services.gonic = {
      enable = true;
      settings = {
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

    systemd.tmpfiles.rules = [
      "d /data/storage/gonic 0755 gonic gonic -"
    ];

    fileSystems."/var/lib/private/gonic" = {
      device = "/data/services/gonic";
      options = ["bind"];
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
