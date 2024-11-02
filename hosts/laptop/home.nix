{inputs, ...}: {
  imports = [
    ./../../user/headless-bundle.nix
    ./../../user/desktop-bundle.nix
    inputs.nur.hmModules.nur
  ];

  home = {
    username = "ominit";
    homeDirectory = "/home/ominit";
    stateVersion = "24.05";
  };
}
