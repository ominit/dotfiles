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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKoQZP933Mc12GwEoUiOt+LZ4b+/5+Bq/T0lSryEXAu9 ominit@makai"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO34kE4UYJuA0Zl+WJOwJyx9J8TsBs9hy4iVSuzwdx9B ominit@mayohiga"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMzamECHWZiUpQvCjaR2xj42NG5rcXGpAUMfds4Du90B ominit@tianxuan-1"
    ];
    packages = packages;
  };
}
