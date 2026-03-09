{...}: {
  config = {
    services.hydra = {
      enable = true;
      hydraURL = "https://hydra.42nd.net";
      port = 10008;
      useSubstitutes = true;
      notificationSender = "hydra@42nd.net";
    };
    nix.buildMachines = [
      {
        hostName = "localhost";
        systems = ["x86_64-linux"];
        supportedFeatures = [
          "kvm"
          "big-parallel"
          "nixos-test"
          "benchmark"
          "ca-derivations"
          "recursive-nix"
          "dynamic-derivations"
        ];
      }
    ];
    fileSystems."/var/lib/postgresql" = {
      device = "/data/services/hydra/db";
      options = ["bind"];
    };

    fileSystems."/var/lib/hydra" = {
      device = "/data/services/hydra/data";
      options = ["bind"];
    };
  };
}
