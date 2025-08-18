{pkgs, ...}: let
  mcpo-config = pkgs.writeText "mcpo-config.json" ''
    {
      "mcpServers": {
        "nixos": {
          "command": "uvx",
          "args": [
            "mcp-nixos"
          ]
        },
        "context7": {
          "url": "https://mcp.context7.com/mcp"
        }
      }
    }
  '';
in {
  config = {
    virtualisation.oci-containers.containers.mcpo-proxy = {
      image = "ghcr.io/open-webui/mcpo:main";
      pull = "newer";
      ports = [
        "127.0.0.1:20002:8000"
      ];
      cmd = [
        "--config"
        "/config.json"
      ];
      volumes = [
        "${mcpo-config}:/config.json"
      ];
      autoStart = true;
    };
  };
}
