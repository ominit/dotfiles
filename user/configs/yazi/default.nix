{
  pkgs,
  inputs,
  ...
}: {
  home.file.".config/yazi/" = {
    source = ./.;
    recursive = true;
  };

  home.packages = [inputs.yazi.packages.${pkgs.system}.default];
}
