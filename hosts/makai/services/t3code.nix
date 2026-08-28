{
  inputs,
  lib,
  ...
}: {
  imports = [inputs.t3code.nixosModules.default];

  config = {
    services.t3code = {
      enable = true;
      user = "ominit";
      group = "users";
      createUser = false;
      dataDir = "/home/ominit/.t3";
      host = "0.0.0.0";
      port = 10009;
      environment.HOME = "/home/ominit";
    };

    systemd.services.t3code.path = lib.mkAfter [
      "/home/ominit/.nix-profile"
      "/nix/profile"
      "/home/ominit/.local/state/nix/profile"
      "/etc/profiles/per-user/ominit"
      "/nix/var/nix/profiles/default"
      "/run/current-system/sw"
    ];
  };
}
