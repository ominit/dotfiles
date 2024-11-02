{
  pkgs,
  inputs,
  ...
}: {
  home.file.".config/yazi/" = {
    source = ./.;
    recursive = true;
  };

  home.packages = with pkgs; [yazi];
}
