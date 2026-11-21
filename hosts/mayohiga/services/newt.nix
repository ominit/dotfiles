{config, ...}: {
  config = {
    sops.secrets."newtEnv" = {
      restartUnits = ["newt.service"];
    };

    services.newt = {
      enable = true;
      environmentFile = config.sops.secrets."newtEnv".path;
      settings.log-level = "INFO";
    };
  };
}
