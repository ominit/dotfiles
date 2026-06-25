{
  config,
  inputs,
  system,
  ...
}: let
  circusModule = inputs.circus.nixosModules.default;
  circusPkgs = inputs.circus.packages.${system};
in {
  imports = [circusModule];

  config = {
    modules.persistence.directories.postgresql = {
      source = "/data/services/postgresql";
      target = "/var/lib/postgresql";
      user = "postgres";
      group = "postgres";
      resetPermissions = true;
    };

    sops.secrets."circus/adminPassword" = {
      owner = "circus";
      group = "circus";
      mode = "0400";
      restartUnits = ["circus-server.service"];
    };

    sops.secrets."circus/githubToken" = {
      owner = "circus";
      group = "circus";
      mode = "0400";
      restartUnits = [
        "circus-server.service"
        "circus-evaluator.service"
        "circus-queue-runner.service"
      ];
    };

    systemd.tmpfiles.rules = [
      "z /data/system/key.secret 0700 circus circus -"
      "Z /nix/var/nix/gcroots/per-user/circus - circus circus -"
    ];

    services.circus = {
      enable = true;

      package = circusPkgs.circus-server;
      evaluatorPackage = circusPkgs.circus-evaluator;
      queueRunnerPackage = circusPkgs.circus-queue-runner;
      migratePackage = circusPkgs.circus-cli;

      database.createLocally = true;
      server.enable = true;
      evaluator.enable = true;
      queueRunner.enable = true;

      settings = {
        server = {
          host = "127.0.0.1";
          port = 10010;
          force_secure_cookies = true;
          rate_limit_rps = 100;
          rate_limit_burst = 20;

          page_access = {
            home = "public";
            projects = "public";
            project = "public";
            jobset = "public";
            jobset_jobs = "public";
            evaluations = "public";
            evaluation = "public";
            builds = "public";
            build = "public";
            channels = "public";
            channel = "public";
            news = "public";
            starred = "authenticated";
            queue = "admin";
            metrics = "admin";
          };
        };

        evaluator = {
          allow_ifd = true;
          restrict_eval = false;
        };

        database.url = "postgresql:///circus?host=/run/postgresql";

        gc.enabled = true;
        gc.max_age_days = 30;

        cache.enabled = true;

        signing = {
          enabled = true;
          key_file = "/data/system/key.secret";
        };

        logs.compress = true;

        # notifications.github_token_file = config.sops.secret."circus/githubToken".path;

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
                {
                  name = "nixosConfigurations-updated";
                  nix_expression = "nixosConfigurations";
                  branch = "flake-update";
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
            {
              name = "t3code-flake";
              repository_url = "https://github.com/ominit/t3code-flake";
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
              name = "helium-browser-flake";
              repository_url = "https://github.com/ominit/helium-browser-flake";
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
          ];

          users = [
            {
              username = "admin";
              password_file = config.sops.secrets."circus/adminPassword".path;
              role = "admin";
              email = "fake@example.com";
            }
          ];
        };
      };
    };
  };
}
