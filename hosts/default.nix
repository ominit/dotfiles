{
  withSystem,
  inputs,
  ...
}: {
  flake.nixosConfigurations = let
    inherit (inputs.self) lib;
    inherit (lib) mkNixosSystem;
  in {
    wsl = mkNixosSystem {
      inherit withSystem;
      hostname = "wsl";
      system = "x86_64-linux";
      modules = [./wsl];
    };
  };
}
