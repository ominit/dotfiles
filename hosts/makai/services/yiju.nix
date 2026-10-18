{
  inputs,
  lib,
  ...
}: {
  imports = [inputs.yiju.nixosModules.default];

  config = {
    services.yiju = {
      enable = true;
      port = 10015;
    };

    systemd.services.yiju = {
      unitConfig.RequiresMountsFor = ["/var/lib/yiju"];
      serviceConfig = {
        DynamicUser = lib.mkForce false;
        User = "yiju";
        Group = "yiju";
        UMask = lib.mkForce "0000";
      };
    };

    modules.persistence.directories.yiju = {
      source = "/data/services/yiju";
      target = "/var/lib/yiju";
      user = "yiju";
      group = "yiju";
      mode = "0777";
      resetPermissions = true;
      resetMode = "0777";
    };

    users.users.yiju = {
      isSystemUser = true;
      group = "yiju";
    };

    users.groups.yiju = {};
  };
}
