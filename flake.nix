{
  description = "my system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:helix-editor/helix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wezterm = {
      url = "github:wez/wezterm?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yazi.url = "github:sxyazi/yazi";

    hyprpanel = {
      url = "github:ominit/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    discidium = {
      url = "github:ominit/discidium";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {...} @ inputs: {
    nixosConfigurations = {
      laptop = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          {
            nixpkgs.overlays = [
              inputs.hyprpanel.overlay
              inputs.rust-overlay.overlays.default
            ];
          }
          inputs.nur.nixosModules.nur
          ./hosts/laptop/configuration.nix
          inputs.chaotic.nixosModules.default
          inputs.auto-cpufreq.nixosModules.default
        ];
      };
    };

    homeConfigurations = {
      "ominit@laptop" = inputs.home-manager.lib.homeManagerConfiguration {
        # pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
        pkgs = import inputs.nixpkgs {
          system = "x86_64-linux";
          overlays = [
            inputs.hyprpanel.overlay
          ];
        };
        modules = [
          inputs.nur.hmModules.nur
          ./hosts/laptop/home.nix
        ];
      };
    };
  };
}
