{pkgs, ...}: let
  username = "ominit"; # TODO automatically figure out username
in {
  home-manager.users."${username}".programs.git = {
    enable = true;
    userName = "ominit";
    userEmail = "86736586+ominit@users.noreply.github.com";
    extraConfig.credential.helper = "manager";
    extraConfig.credential.credentialStore = "cache";

    extraConfig.core.pager = "delta";
    extraConfig.interactive.diffFilter = "delta --color-only";
    extraConfig.delta = {
      dark = true;
      line-numbers = true;
    };
  };

  users.users."${username}".packages = with pkgs; [git git-credential-manager];
}