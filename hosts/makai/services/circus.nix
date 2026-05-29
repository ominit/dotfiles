{
  inputs,
  system,
  ...
}: let
  circusModule = inputs.circus.nixosModules.default;
  circusPkgs = inputs.circus.packages.${system};
in {
  imports = [circusModule];

  config = {
    services.circus = {
      enable = true;

      package = circusPkgs.circus-server;
      evaluatorPackage = circusPkgs.circus-evaluator;
      queueRunnerPackage = circusPkgs.circus-queue-runner;
      migratePackage = circusPkgs.circus-migrate-cli;

      database.createLocally = true;
      server.enable = true;
      evaluator.enable = true;
      queueRunner.enable = true;

      settings = {
        server = {
          host = "127.0.0.1";
          port = 10010;
          force_secure_cookies = true;
        };

        database.url = "postgresql:///circus?host=/run/postgresql";

        gc.enabled = true;
        gc.max_age_days = 90;
        cache.enabled = true;
        logs.compress = true;

        declarative = {
          projects = [
            {
              name = "dotfiles";
              repository_url = "https://github.com/ominit/dotfiles";
              jobsets = [
                {
                  name = "checks";
                  nix_expression = "checks";
                }
                {
                  name = "nixosConfigurations";
                  nix_expression = "nixosConfigurations";
                }
              ];
            }
            {
              name = "dotfiles-flake-update";
              repository_url = "https://github.com/ominit/dotfiles/tree/flake-update";
              jobsets = [
                {
                  name = "checks";
                  nix_expression = "checks";
                }
                {
                  name = "nixosConfigurations";
                  nix_expression = "nixosConfigurations";
                }
              ];
            }
            {
              name = "kraai";
              repository_url = "https://github.com/kraai-io/kraai";
              jobsets = [
                {
                  name = "checks";
                  nix_expression = "checks";
                }
                {
                  name = "packages";
                  nix_expression = "packages";
                }
              ];
            }
            {
              name = "circus";
              repository_url = "https://github.com/manic-systems/circus";
              jobsets = [
                {
                  name = "packages";
                  nix_expression = "packages.x86_64-linux";
                }
              ];
            }
          ];

          users = [
            # {
            #   username = "";
            #   password = "";
            #   role = "admin";
            #   email = "";
            # }
          ];
        };
      };
    };
  };
}
