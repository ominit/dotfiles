{...}: {
  filesIn = dir:
    (map (fname: dir + "/${fname}"))
    (builtins.attrNames (builtins.readDir dir));
}
