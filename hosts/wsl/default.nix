{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  config = {
    modules.programs.helix = {
      enable = true;
      package = inputs.helix.packages."${pkgs.system}".helix;
    };

    wsl.enable = true;
    wsl.defaultUser = "ominit";

    # TODO need to setup correctly
    users.users."ominit" = {
      isNormalUser = true;
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.nushell;
      packages = with pkgs; [starship alejandra];
    };

    system.stateVersion = "25.05";
  };
}
