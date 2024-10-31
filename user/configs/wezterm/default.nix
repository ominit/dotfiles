{ pkgs, inputs, ... }: {
    home.file.".config/wezterm/" = {
        source = ./.;
        recursive = true;
    };

    home.packages = with pkgs; [ inputs.wezterm.packages.${pkgs.system}.default ];
}
