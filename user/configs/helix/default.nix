{ pkgs, inputs, ... }: {
    home.file.".config/helix/" = {
        source = ./.;
        recursive = true;
    };

    home.packages = with pkgs; [ inputs.helix.packages."${pkgs.system}".helix ];
}
