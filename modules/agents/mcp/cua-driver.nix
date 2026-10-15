{
  inputs,
  lib,
  pkgs,
}: {
  command = lib.getExe inputs.cua.packages.${pkgs.stdenv.hostPlatform.system}.cua-driver;
  args = ["mcp" "--socket" "/home/ominit/.cache/cua-driver/cua-driver.sock"];
  env.CUA_DRIVER_RS_TELEMETRY_ENABLED = "0";
}
