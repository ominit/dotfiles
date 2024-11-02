{pkgs, ...}: {
  programs.git = {
    enable = true;
    userName = "ominit";
    userEmail = "86736586+ominit@users.noreply.github.com";
  };

  home.packages = with pkgs; [git gh];
}
