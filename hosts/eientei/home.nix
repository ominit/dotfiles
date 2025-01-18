{
  outputs,
  inputs,
  pkgs,
  ...
}: {
  home = {
    username = "ominit";
    homeDirectory = "/home/ominit";
    stateVersion = "24.05";
    pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 20;
      gtk.enable = true;
      x11 = {
        enable = true;
        defaultCursor = true;
      };
    };
  };
}
