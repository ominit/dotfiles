{
  inputs,
  ...
}: {
  imports = [inputs.odysseus.nixosModules.default];

  config = {
    services.odysseus = {
      enable = true;
      port = 10011;
      dataDir = "/data/services/odysseus";
      llamaCpp.enable = true;
      # extraPythonPackages = ps: [ps.hf-transfer ps.rembg ps.diffusers ps.vllm];
      extraPythonPackages = ps: [ps.hf-transfer ps.rembg];
    };

    systemd.tmpfiles.rules = [
      "d /data/services/odysseus 0755 odysseus odysseus -"
      "d /data/services/odysseus/models 0755 odysseus odysseus -"
      "Z /data/services/odysseus - odysseus odysseus -"
    ];
  };
}
