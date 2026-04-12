{
  inputs,
  pkgs,
  config,
  system,
  ...
}: let
  packages = import ./packages.nix {
    inherit inputs pkgs system;
  };
in {
  users.users.ominit = {
    isNormalUser = true;
    description = "ominit";
    extraGroups = ["networkmanager" "wheel"];
    shell = config.modules.programs.nushell.package;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ0KtEKf415TSy1cD+ED/33V7YTtY/I7FZjNR/FNpzXf ominit@wsl"
    ];
    packages = packages;
  };
}
