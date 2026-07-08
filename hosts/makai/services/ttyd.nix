{inputs, ...}: {
  config = {
    # TEMP https://github.com/NixOS/nixpkgs/pull/531941
    nixpkgs.overlays = [
      (_final: prev: {
        ttyd = inputs.nixpkgs-ominit.legacyPackages.${prev.system}.ttyd;
      })
    ];

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
