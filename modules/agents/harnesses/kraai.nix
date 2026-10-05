{
  lib,
  pkgs,
}: {
  package = pkgs.writeShellScriptBin "kraai" ''
    exec ${lib.getExe pkgs.nix} run github:kraai-io/kraai -- "$@"
  '';
  settingsType = (pkgs.formats.toml {}).type;

  configure = cfg: {
    package = cfg.package;
    files = {};
    tmpfiles = [];
  };
}
