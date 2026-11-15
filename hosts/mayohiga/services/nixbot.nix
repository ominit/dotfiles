{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [inputs.nixbot.nixosModules.nixbot];

  config = {
    services.nixbot = {
      enable = true;

      domain = "nixbot.42nd.net";
      port = 10001;
      useHTTPS = true;
      nginx.enable = false;

      admins = ["github:ominit"];
      github = {
        enable = true;
        appId = 4138076;
        appSecretKeyFile = config.sops.secrets."nixbot/appSecretKey".path;
        # The webhook secret configured in the GitHub App settings.
        webhookSecretFile = config.sops.secrets."nixbot/webhookSecret".path;
        # OAuth credentials for the login button (from the same GitHub App).
        oauthId = "Iv23liyPwXJ18Vcvc2BA";
        oauthSecretFile = config.sops.secrets."nixbot/oauthSecret".path;
      };

      branches.merge-queue = {
        matchGlob = "gh-readonly-queue/*";
        registerGCRoots = true;
      };

      buildSystems = ["x86_64-linux" "aarch64-linux"];
      buildMaxSilentTime = 60 * 60;
      packages.nixbot = let
        python3Packages = pkgs.python3.pkgs;
        # nixbot.nix only defines passthru.tests.pytest when handed the package itself.
        nixbot =
          (python3Packages.callPackage "${inputs.nixbot}/packages/nixbot.nix" {
            inherit (config.services.nixbot.packages) nix-eval-jobs;
            inherit nixbot;
            nixbot-cli = python3Packages.callPackage "${inputs.nixbot}/packages/nixbot-cli.nix" {};
          }).overridePythonAttrs (old: {
            patches =
              (old.patches or [])
              ++ [
                ../../../patches/nixbot-fast-eval.patch
                ../../../patches/nixbot-retry-disk-full.patch
                ../../../patches/nixbot-branch-gcroots.patch
                ../../../patches/nixbot-silent-timeout-retry.patch
                ../../../patches/nixbot-build-priority.patch
                ../../../patches/nixbot-merge-queue-fail-fast.patch
              ];
          });
      in
        nixbot;
    };

    # The root directory rule upstream does not repair descendants left
    # with an old nixbot UID after system-user allocation changes.
    systemd.tmpfiles.rules = [
      "Z /nix/var/nix/gcroots/per-user/nixbot - nixbot nixbot - -"
    ];

    sops.secrets."nixbot/appSecretKey" = {
      owner = "nixbot";
      group = "nixbot";
      mode = "0400";
      restartUnits = ["nixbot.service"];
    };

    sops.secrets."nixbot/webhookSecret" = {
      owner = "nixbot";
      group = "nixbot";
      mode = "0400";
      restartUnits = ["nixbot.service"];
    };

    sops.secrets."nixbot/oauthSecret" = {
      owner = "nixbot";
      group = "nixbot";
      mode = "0400";
      restartUnits = ["nixbot.service"];
    };

    modules.persistence.directories.nixbot = {
      source = "/data/services/nixbot";
      target = "/var/lib/nixbot";
      user = "nixbot";
      group = "nixbot";
      mode = "0700";
    };

    modules.persistence.directories.postgresql = {
      source = "/data/services/postgresql";
      target = "/var/lib/postgresql";
      user = "postgres";
      group = "postgres";
      resetPermissions = true;
    };
  };
}
