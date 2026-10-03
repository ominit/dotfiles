{
  config,
  inputs,
  lib,
  pkgs,
  system,
  ...
}: let
  configPath = "/var/lib/cliproxyapi/config.yaml";
  managedConfig = pkgs.writeText "cliproxyapi-managed.json" (builtins.toJSON config.services.cliproxyapi.settings);
in {
  config = {
    services.cliproxyapi = {
      enable = true;
      package = inputs.multiverse.multiverse.${system}.latest.cliproxyapi;
      settings = {
        server = {
          host = "0.0.0.0";
          port = 10014;
        };
        oauth = {
          auth-dir = "/var/lib/cliproxyapi/auth";
        };
        management = {
          allow-remote = true;
        };
      };
    };

    modules.persistence.directories.cliproxyapi = {
      source = "/data/services/cliproxyapi";
      target = "/var/lib/cliproxyapi";
      user = "cliproxyapi";
      group = "cliproxyapi";
      mode = "0700";
    };

    systemd.services.cliproxyapi = {
      unitConfig.RequiresMountsFor = ["/var/lib/cliproxyapi"];
      serviceConfig = {
        RuntimeDirectory = "cliproxyapi";
        RuntimeDirectoryMode = "0700";
      };
      preStart = lib.mkForce ''
        umask 077
        if [ -f ${configPath} ]; then
          ${lib.getExe pkgs.yq-go} -o=json '.' ${configPath} > /run/cliproxyapi/current.json
        else
          CLIPROXY_API_KEY=$(${lib.getExe pkgs.openssl} rand -hex 32)
          CLIPROXY_MANAGEMENT_KEY=$(${lib.getExe pkgs.openssl} rand -hex 32)
          export CLIPROXY_API_KEY CLIPROXY_MANAGEMENT_KEY
          ${lib.getExe pkgs.jq} -n '{access: {"api-keys": [env.CLIPROXY_API_KEY]}, management: {"secret-key": env.CLIPROXY_MANAGEMENT_KEY}}' > /run/cliproxyapi/current.json
          cp /run/cliproxyapi/current.json /var/lib/cliproxyapi/bootstrap-credentials.json
          unset CLIPROXY_API_KEY CLIPROXY_MANAGEMENT_KEY
        fi
        ${lib.getExe pkgs.jq} -s '.[0] * .[1]' /run/cliproxyapi/current.json ${managedConfig} > ${configPath}.tmp
        mv ${configPath}.tmp ${configPath}
      '';
    };
  };
}
