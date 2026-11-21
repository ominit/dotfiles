{
  config,
  lib,
  ...
}: let
  inherit (lib) imap1 mapAttrs mkIf mkOption optionalAttrs types;

  cfg = config.modules.pangolin;

  resourceType = types.submodule ({name, ...}: {
    options = {
      name = mkOption {
        type = types.str;
        default = name;
        description = "Display name in the Pangolin dashboard.";
      };

      domain = mkOption {
        type = types.str;
        description = "Public domain served by Pangolin.";
      };

      port = mkOption {
        type = types.port;
        description = "Local port newt forwards to.";
      };

      sso = mkOption {
        type = types.bool;
        default = true;
        description = "Require Pangolin SSO.";
      };

      bypassPaths = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Path patterns that skip Pangolin auth, in priority order.";
      };

      healthPath = mkOption {
        type = types.nullOr types.str;
        default = "/";
        description = "Health check path, or null to disable the health check.";
      };

      healthInterval = mkOption {
        type = types.ints.positive;
        default = 5;
        description = "Seconds between health checks while healthy.";
      };

      extraTargets = mkOption {
        type = types.listOf (types.attrsOf types.anything);
        default = [];
        description = "Additional raw blueprint targets.";
      };
    };
  });

  mkResource = _: r: {
    inherit (r) name;
    mode = "http";
    enabled = true;
    full-domain = r.domain;
    ssl = true;
    auth.sso-enabled = r.sso;
    rules =
      imap1 (priority: value: {
        action = "allow";
        match = "path";
        inherit value priority;
        enabled = true;
      })
      r.bypassPaths;
    targets =
      [
        ({
            method = "http";
            hostname = "localhost";
            inherit (r) port;
            enabled = true;
            priority = 100;
          }
          // optionalAttrs (r.healthPath != null) {
            healthcheck = {
              hostname = "localhost";
              inherit (r) port;
              enabled = true;
              path = r.healthPath;
              scheme = "http";
              mode = "http";
              interval = r.healthInterval;
              unhealthy-interval = 30;
              timeout = 5;
              follow-redirects = true;
              method = "GET";
              healthy-threshold = 1;
              unhealthy-threshold = 1;
            };
          })
      ]
      ++ r.extraTargets;
  };
in {
  options.modules.pangolin.resources = mkOption {
    type = types.attrsOf resourceType;
    default = {};
    description = "Pangolin public resources served through this host's newt site, keyed by resource identifier.";
  };

  config = mkIf (cfg.resources != {}) {
    services.newt.blueprint.proxy-resources = mapAttrs mkResource cfg.resources;
  };
}
