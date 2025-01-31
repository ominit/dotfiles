{
  description = "my system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
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
      url = "github:Jas-SinghFSU/HyprPanel";
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

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    jujutsu = {
      url = "github:jj-vcs/jj";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {...} @ inputs: let
    helperLib = import ./helperLib/default.nix {inherit inputs;};
  in {
    nixosConfigurations = {
      laptop = helperLib.mkSystem ./hosts/laptop/configuration.nix;
      luffy = helperLib.mkSystem ./hosts/luffy/configuration.nix;
      desktop = helperLib.mkSystem ./hosts/desktop/configuration.nix;
      eientei = helperLib.mkSystem ./hosts/eientei/configuration.nix;
    };

    homeConfigurations = {
      "ominit@laptop" = helperLib.mkHome "x86_64-linux" ./hosts/laptop/home.nix;
      "ominit@desktop" = helperLib.mkHome "x86_64-linux" ./hosts/desktop/home.nix;
      "ominit@luffy" = helperLib.mkHome "aarch64" ./hosts/luffy/home.nix;
      "ominit@eientei" = helperLib.mkHome "x86_64-linux" ./hosts/eientei/home.nix;
    };

    programModules.default = ./programModules;
  };
}
