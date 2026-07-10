{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [inputs.nixbot.nixosModules.nixbot];

  config = {
    services.nixbot = {
      enable = true;

      domain = "nixbot.42nd.net";
      port = 10012;
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
        oauthPrivateRepoScope = true;
      };

      buildSystems = ["x86_64-linux" "aarch64-linux"];
    };

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

    modules.persistence.directories.postgresql = {
      source = "/data/services/postgresql";
      target = "/var/lib/postgresql";
      user = "postgres";
      group = "postgres";
      resetPermissions = true;
    };
  };
}
