{
  description = "my system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix.url = "github:helix-editor/helix/master";

    wezterm.url = "github:wez/wezterm?dir=nix";

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = {...} @ inputs: {
    nixosConfigurations = {
      laptop = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          inputs.nur.nixosModules.nur
          ./hosts/laptop/configuration.nix
        ];
      };
    };

    homeConfigurations = {
      "ominit@laptop" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
        modules = [
          inputs.nur.hmModules.nur
          ./hosts/laptop/home.nix
        ];
      };
    };
  };
}
