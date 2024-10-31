{ pkgs, inputs, ... }: {
    home.file.".config/btop/" = {
        source = ./.;
        recursive = true;
    };

    home.packages = with pkgs; [ btop ];
}
