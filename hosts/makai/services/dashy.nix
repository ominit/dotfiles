{pkgs, ...}: let
  dashyConfig = pkgs.writeText "dashy-config.yaml" (builtins.readFile ./dashy.yaml);
in {
  config = {
    virtualisation.oci-containers.containers.dashy = {
      image = "lissy93/dashy";
      ports = [
        "127.0.0.1:10003:8080"
      ];
      environment = {
        NODE_ENV = "production";
      };
      autoStart = true;
      volumes = [
        "${dashyConfig}:/app/public/conf.yml"
      ];
    };
  };
}
