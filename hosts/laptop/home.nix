{inputs, ...}: {
  imports = [
    ./../../user/headless-bundle.nix
    ./../../user/desktop-bundle.nix
  ];

  home = {
    username = "ominit";
    homeDirectory = "/home/ominit";
    stateVersion = "24.05";
  };
}
