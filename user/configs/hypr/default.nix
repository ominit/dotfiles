{ pkgs, inputs, ... }: {
    home.file.".config/hypr/" = {
        source = ./.;
        recursive = true;
    };

    home.packages = with pkgs; [ inputs.hyprland.packages.${pkgs.system}.hyprland swww hyprlock hypridle tofi ];
}
