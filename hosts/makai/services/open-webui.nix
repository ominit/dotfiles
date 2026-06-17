{
  inputs,
  system,
  config,
  lib,
  ...
}: {
  config = {
    services.open-webui = {
      enable = true;
      # wont compile otherwise, i assume cuda messes with it.
      package =
        (import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }).open-webui;
      host = "0.0.0.0";
      environment = {
        OLLAMA_BASE_URL = "http://localhost:20001";
        ENABLE_SIGNUP_PASSWORD_CONFIRMATION = "true";
        NLTK_DATA = "${config.services.open-webui.stateDir}";
        ENV = "dev";
      };
      port = 10007;
    };

    systemd.services.open-webui.serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "open-webui";
      Group = "open-webui";
    };

    modules.persistence.directories.open-webui = {
      source = "/data/services/open-webui";
      target = "/var/lib/open-webui";
      user = "open-webui";
      group = "open-webui";
      resetPermissions = true;
    };

    users.users.open-webui = {
      isSystemUser = true;
      group = "open-webui";
    };

    users.groups.open-webui = {};
  };
}
