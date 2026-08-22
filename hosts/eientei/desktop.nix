{
  lib,
  pkgs,
  ...
}: {
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  fonts.packages = with pkgs;
    [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.gnome.gnome-keyring.enable = true;
  services.gvfs.enable = true;
  services.upower.enable = true;
  services.udev.extraHwdb = ''
    battery:*:*:dmi:*
     CHARGE_LIMIT=80,85
  '';
  services.displayManager.ly.enable = true;
}
