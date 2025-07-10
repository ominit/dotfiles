{...}: {
  config = {
    services.syncthing = {
      enable = true;
      dataDir = "/data/services/syncthing";
      settings = {
        devices = {
          "win11" = {id = "PDG7QZA-YPB5TEZ-GT7L3YF-MJPS6XI-YDGWK6T-7EILW4O-PHOMCOS-J5T4NAB";};
        };
        folders = {
          "music" = {
            path = "/data/storage/gonic/music/sync";
			id = "2navz-o5dtt";
            devices = ["win11"];
			type = "receiveonly";
          };
        };
      };
    };

    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder
  };
}
