{
  inputs,
  lib,
  pkgs,
}: {
  package = inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.minimal;
  settingsType = (pkgs.formats.yaml {}).type;

  configure = cfg: {
    package = cfg.package;

    files = lib.mapAttrs' (name: source:
      lib.nameValuePair ".hermes/skills/${name}" {
        inherit source;
        clobber = true;
      })
    cfg.skills;

    tmpfiles = [
      "d %h/.hermes 0700 - - -"
      "d %h/.hermes/skills 0700 - - -"
    ];
  };
}
