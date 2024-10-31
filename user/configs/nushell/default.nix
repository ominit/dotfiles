{ pkgs, inputs, ... }: {
    home.file.".config/nushell/" = {
        source = ./.;
        recursive = true;
    };

    home.packages = with pkgs; [ nushell fish carapace starship ];
}
