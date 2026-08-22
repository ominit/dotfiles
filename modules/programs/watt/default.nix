{
  lib,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;

  pkg = "watt";
in {
  disabledModules = ["services/hardware/watt.nix"];

  imports = [
    inputs.watt.nixosModules.watt
  ];

  config = mkIf config.modules.programs."${pkg}".enable {
    services.watt = {
      enable = true;
      settings = fromTOML (builtins.readFile ./config/config.toml);
    };

    systemd.services.watt.environment.WATT_CONFIG = "/etc/watt.toml";
  };

  options.modules.programs."${pkg}" = {
    enable = mkEnableOption "enable watt";
  };
}
