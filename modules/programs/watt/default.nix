{
  lib,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;

  pkg = "watt";
in {
  imports = [
    inputs.watt.nixosModules.watt
  ];

  config = mkIf config.modules.programs."${pkg}".enable {
    services.watt = {
      enable = true;
      settings = fromTOML (builtins.readFile ./config/config.toml);
    };
  };

  options.modules.programs."${pkg}" = {
    enable = mkEnableOption "enable watt";
  };
}
