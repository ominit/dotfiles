{
  withSystem,
  inputs,
  ...
}: {
  flake.nixosConfigurations = let
    inherit (inputs.self) lib;
    inherit (lib) mkNixosSystem;

    defaultModules = [
      inputs.sops-nix.nixosModules.sops
      inputs.hjem.nixosModules.default
      inputs.nix-index-database.nixosModules.nix-index
      inputs.chaotic.nixosModules.nyx-overlay
      {
        programs.nix-index-database.comma.enable = true;
        sops.defaultSopsFormat = "yaml";
        # Roots of the intermediates whose private keys were compromised by
        # eMudhra in Oct 2026. Incident record: Mozilla bug 2083449
        # https://bugzilla.mozilla.org/show_bug.cgi?id=2083449
        # "emSign ECC Root CA - G3" was removed from the Mozilla store in NSS
        # 3.131.1; drop that entry once nixpkgs updates cacert past 3.126,
        # otherwise the cacert build fails on an unknown blocklist entry.
        security.pki.caCertificateBlacklist = [
          "Comodo AAA Services root"
        ];
      }
    ];
  in {
    eientei = mkNixosSystem {
      inherit withSystem;
      hostname = "eientei";
      system = "x86_64-linux";
      modules = defaultModules ++ [./eientei];
    };

    makai = mkNixosSystem {
      inherit withSystem;
      hostname = "makai";
      system = "x86_64-linux";
      modules = defaultModules ++ [./makai];
    };

    wsl = mkNixosSystem {
      inherit withSystem;
      hostname = "wsl";
      system = "x86_64-linux";
      modules = defaultModules ++ [./wsl];
    };
  };
}
