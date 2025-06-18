{
  withSystem,
  inputs,
  ...
}: {
  flake.nixosConfigurations = let
    inherit (inputs.self) lib;
    inherit (lib) mkNixosSystem;
  in {
    makai = mkNixosSystem {
      inherit withSystem;
      hostname = "makai";
      system = "x86_64-linux";
      modules = [./makai];
    };

    wsl = mkNixosSystem {
      inherit withSystem;
      hostname = "wsl";
      system = "x86_64-linux";
      modules = [./wsl];
    };
  };
}
