{
  inputs,
  lib,
  ...
}: let
  extendedLib = {
    builders = import ./builders.nix {inherit inputs lib;};
    misc = import ./misc.nix;
  };

  libEx = {
    inherit (extendedLib.builders) mkNixosSystem;
    inherit (extendedLib.misc) filesIn;
  };
in {
  flake.lib = libEx;
}
