{
  pkgs,
  inputs,
  ...
}: {
  home.file.".config/bat/" = {
    source = ./.;
    recursive = true;
  };

  home.packages = with pkgs; [bat];
}
