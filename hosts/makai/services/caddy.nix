{config, ...}: {
  config = {
    services.caddy = {
      enable = true;
      dataDir = "/data/services/caddy";
      virtualHosts = {
        "grafana.makai.ominit.io" = {
          extraConfig = ''
            reverse_proxy http://${config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port} {
              # Standard headers for reverse proxying
              header_up Host {http.request.host}
              header_up X-Real-IP {remote_ip}
              header_up X-Forwarded-For {remote_ip}
              header_up X-Forwarded-Proto {http.request.scheme}
            }
            tls internal
          '';
        };

        "gonic.makai.ominit.io" = {
          extraConfig = ''
            reverse_proxy http://${config.services.gonic.settings.listen-addr} {
              # Standard headers for reverse proxying
              header_up Host {http.request.host}
              header_up X-Real-IP {remote_ip}
              header_up X-Forwarded-For {remote_ip}
              header_up X-Forwarded-Proto {http.request.scheme}
            }
            tls internal
          '';
        };
      };
    };

    networking.firewall.allowedTCPPorts = [80 443];
  };
}
