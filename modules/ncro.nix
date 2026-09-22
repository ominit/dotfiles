{
  inputs,
  lib,
  ...
}: {
  imports = [inputs.ncro.nixosModules.default];

  services.ncro = {
    enable = true;
    socketActivation = true;
    settings = {
      server.listen = "127.0.0.1:17890";
      logging.timestamps = false;
      upstreams = [
        {
          url = "https://hermes-agent.cachix.org";
          public_key = "hermes-agent.cachix.org-1:jN3pjR50Mxi4SESKC/FIMNM6/LCosvPk2VUwzVvebzU=";
        }
        {
          url = "https://cache.nixos.org";
          public_key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
        }
        {
          url = "https://harmonia.42nd.net/";
          public_key = "harmonia.42nd.net:JD9qs95wYpbknQHbJRBHs/mW8kIHbWeh5tQhVu3+B3A=";
        }
        {
          url = "https://nix-community.cachix.org";
          public_key = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
        }
        {
          url = "https://attic.xuyh0120.win/lantian";
          public_key = "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=";
        }
        {
          url = "https://cache.numtide.com";
          public_key = "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=";
        }
      ];
    };
  };

  nix.settings.substituters = lib.mkForce ["http://127.0.0.1:17890"];
}
