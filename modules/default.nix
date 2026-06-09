{inputs, ...}: let
  inherit (inputs.self) lib;
  inherit (lib) filesIn;

  programs = filesIn ./programs;
  persistence = filesIn ./persistence;
in {
  imports = [] ++ programs ++ persistence;
}
