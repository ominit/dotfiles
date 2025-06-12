{
  inputs,
  lib,
  ...
}: let
  extendedLib = {
    builders = import ./builders.nix {inherit inputs lib;};
  };

  libEx = {
    inherit (extendedLib.builders) mkNixosSystem;
  };
in {
  flake.lib = libEx;
}
