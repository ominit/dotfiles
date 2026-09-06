{inputs, ...}: let
  inherit (inputs.self) lib;
  inherit (lib) filesIn;

  programs = filesIn ./programs;
  persistence = filesIn ./persistence;
in {
  imports = [./agents] ++ programs ++ persistence;
}
