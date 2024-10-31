{ pkgs, inputs, ... }: {
    # home.file.".config/helix/" = {
    #     source = ./.;
    #     recursive = true;
    # };

    programs.git = {
        enable = true;
        userName = "ominit";
        userEmail = "86736586+ominit@users.noreply.github.com";
    };
}
