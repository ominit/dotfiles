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
      inputs.chaotic.nixosModules.default
      {
        sops.defaultSopsFormat = "yaml";
      }
    ];
  in {
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
