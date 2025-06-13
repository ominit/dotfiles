{inputs, ...}: let
  inherit (inputs.self) lib;
  inherit (lib) filesIn;

  programs = filesIn ./programs;
in {
  imports = [] ++ programs;
}
