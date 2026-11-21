{
  config,
  lib,
  pkgs,
  multiverse,
  ...
}: let
  configPath = "/var/lib/cliproxyapi/config.yaml";
  managedConfig = pkgs.writeText "cliproxyapi-managed.json" (builtins.toJSON config.services.cliproxyapi.settings);
in {
  config = {
    services.cliproxyapi = {
      enable = true;
      package = multiverse.latest.cliproxyapi.overrideAttrs (old: {
        patches =
          (old.patches or [])
          ++ [
            ../../../patches/cliproxyapi-claude-ratelimit-headers.patch
            ../../../patches/cliproxyapi-ratelimit-reset-grace.patch
            ../../../patches/cliproxyapi-fill-first-weekly-reset.patch
          ];
      });
      settings = {
        server = {
          host = "127.0.0.1";
          port = 10014;
          trusted-proxies = ["127.0.0.1" "::1"];
          shutdown-timeout = 60;
        };
        oauth = {
          auth-dir = "/var/lib/cliproxyapi/auth";
        };
        management = {
          allow-remote = true;
        };
        routing = {
          strategy = "fill-first";
          session-affinity = true;
          session-affinity-subagents = true;
          session-affinity-ttl = "24h";
          session-affinity-rebind-on = "quota";
          retry.request-retry = 0;
          cooldown = {
            save-cooldown-status = true;
            transient-error-cooldown-seconds = -1;
          };
        };
        requests.tls-handshake-timeout-seconds = 15;
        upstream.claude.header-defaults.native-entrypoints = ["t3-code"];
      };
    };

    modules.pangolin.resources.warm-southeastern-shrew = {
      name = "cliproxyapi";
      domain = "cliproxyapi.42nd.net";
      inherit (config.services.cliproxyapi.settings.server) port;
      healthPath = "/healthz";
      bypassPaths = ["/v1/*" "/v1beta/*" "/backend-api/codex/*"];
    };

    modules.autodeploy.gates.cliproxyapi = {
      units = ["cliproxyapi.service"];
      path = [pkgs.systemd pkgs.gnugrep];
      script = ''
        requests=$(journalctl -u cliproxyapi.service --since -5min -q -o cat | grep -cE 'POST +"/v1/|selector\.go' || true)
        if [ "$requests" -gt 0 ]; then
          echo "$requests LLM requests in the last 5 minutes"
          exit 1
        fi
      '';
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
