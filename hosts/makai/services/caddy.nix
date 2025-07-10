{config, ...}: {
  config = {
    services.caddy = {
      enable = true;
      dataDir = "/data/services/caddy";
      virtualHosts = {
        "makai.ominit.io" = {
          extraConfig = ''
            handle /grafana* {
              reverse_proxy http://${config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port} {
                header_up Host {http.request.host}
                header_up X-Real-IP {remote_ip}
                header_up X-Forwarded-For {remote_ip}
                header_up X-Forwarded-Proto {http.request.scheme}
              }
            }

            handle /gonic* {
              reverse_proxy http://${config.services.gonic.settings.listen-addr} {
                header_up Host {http.request.host}
                header_up X-Real-IP {remote_ip}
                header_up X-Forwarded-For {remote_ip}
                header_up X-Forwarded-Proto {http.request.scheme}
              }
            }
            tls internal
          '';
        };
      };
    };

    networking.firewall.allowedTCPPorts = [80 443];
  };
}
