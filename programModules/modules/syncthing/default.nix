{...}: {
  services.syncthing = {
    enable = true;
    user = "ominit";
    group = "users";
    dataDir = "/home/ominit/sync";
    settings = {
      devices = {
        "eientei" = {id = "LTFGRWV-TINX46T-GKXUXY3-JLVSZKM-GHVNX7R-EP42NBR-YI7P3OZ-RUB4QQF";};
        "win11" = {id = "PDG7QZA-YPB5TEZ-GT7L3YF-MJPS6XI-YDGWK6T-7EILW4O-PHOMCOS-J5T4NAB";};
      };
      folders = {
        "obsidian-notes" = {
          "path" = "/home/ominit/sync/obsidian-notes";
          devices = ["eientei" "win11"];
        };
      };
    };
  };

  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder
}
