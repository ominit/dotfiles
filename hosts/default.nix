{
  withSystem,
  inputs,
  ...
}: {
  flake.nixosConfigurations = let
    inherit (inputs.self) lib;
    inherit (lib) mkNixosSystem;
  in {
    eientei = mkNixosSystem {
      inherit withSystem;
      hostname = "eientei";
      system = "x86_64-linux";
      modules = [./eientei];
    };
  };
}
