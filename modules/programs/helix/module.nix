{
  pkgs,
  inputs,
  ...
}: {
  hjem.users."ominit" = {
  };

  users.users."ominit".packages = with pkgs; [
    inputs.helix.packages."${pkgs.system}".helix
    nil
    alejandra
  ];
}
