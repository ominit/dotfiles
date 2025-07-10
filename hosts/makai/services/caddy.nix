{config, ...}: {
  config = {
    services.caddy = {
      enable = true;
      dataDir = "/data/services/caddy";
      virtualHosts = {
        "makai.ominit.io" = {
          extraConfig = ''
            handle /grafana* {
              reverse_proxy http://${config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}
            }

            handle_path /gonic* {
              reverse_proxy http://${builtins.head config.services.gonic.settings.listen-addr}
            }
            tls internal
          '';
        };
      };
    };

    networking.firewall.allowedTCPPorts = [80 443];
  };
}
