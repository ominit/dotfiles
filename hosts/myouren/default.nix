{
  inputs,
  system,
  pkgs,
  ...
}: {
  imports = [
    # {hardware.facter.reportPath = ./facter.json;}
    inputs.disko.nixosModules.default
    ./disko.nix
    ./boot.nix
    ./locale.nix
    ./networking.nix
    ./desktop.nix
    ./user.nix
  ];

  config = {
    modules.programs = {
      helix = {
        enable = true;
        package = inputs.helix.packages.${system}.default;
      };
      bat.enable = true;
      git = {
        enable = true;
        deltaPager = true;
      };
      nushell = {
        enable = true;
        extraSources = [./env-vars.nu];
      };
      btop.enable = true;
      yazi.enable = true;
      ghostty.enable = true;
      niri = {
        enable = true;
        package = inputs.niri.packages.${system}.default;
      };
      vicinae.enable = true;
      noctalia.enable = true;
      noctalia.package = inputs.noctalia.packages.${system}.default;
      jujutsu.enable = true;
      # watt.enable = true;
      # zellij.enable = true;
    };

    # programs.nix-ld = {
    #   enable = true;
    #   libraries = with pkgs; [
    #     glib
    #     nspr
    #     nss
    #     dbus
    #     atk
    #     cups
    #     cairo
    #     gtk3
    #     pango
    #     libx11
    #     libxcomposite
    #     libxdamage
    #     libxext
    #     libxfixes
    #     libxrandr
    #     libgbm
    #     expat
    #     libxcb
    #     libxkbcommon
    #     alsa-lib
    #     libglvnd
    #   ];
    # };

    nix.settings.trusted-users = ["root" "ominit"];

    services.resolved.enable = true;

    # systemd.user.units."app-org.fcitx.Fcitx5@autostart.service".enable = false;
    # i18n.inputMethod = {
    #   type = "fcitx5";
    #   enable = true;
    #   fcitx5 = {
    #     waylandFrontend = true;
    #     addons = with pkgs; [
    #       qt6Packages.fcitx5-chinese-addons
    #       fcitx5-rime
    #       fcitx5-lua
    #       fcitx5-mozc
    #       fcitx5-gtk
    #       fcitx5-rose-pine
    #       fcitx5-tokyonight
    #       kdePackages.fcitx5-qt
    #     ];
    #   };
    # };

    i18n.supportedLocales = ["zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8"];

    # services.syncthing = {
    #   enable = true;
    #   user = "ominit";
    #   group = "users";
    #   dataDir = "/home/ominit/sync";
    #   settings = {
    #     devices = {
    #       "win11" = {id = "PDG7QZA-YPB5TEZ-GT7L3YF-MJPS6XI-YDGWK6T-7EILW4O-PHOMCOS-J5T4NAB";};
    #     };
    #     folders = {
    #       "obsidian-notes" = {
    #         "path" = "/home/ominit/sync/obsidian-notes";
    #         devices = ["win11"];
    #       };
    #     };
    #   };
    # };

    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder

    nix.optimise = {
      automatic = true;
    };

    system.stateVersion = "25.11";
  };
}
