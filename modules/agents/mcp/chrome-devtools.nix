{
  lib,
  pkgs,
  ...
}: {
  command = lib.getExe' pkgs.nodejs "npx";
  args = ["-y" "chrome-devtools-mcp@1.11.0" "--browser-url=http://127.0.0.1:9222" "--no-performance-crux"];
  env = {
    PATH = "${pkgs.nodejs}/bin:/run/current-system/sw/bin";
    CHROME_DEVTOOLS_MCP_NO_USAGE_STATISTICS = "1";
    CHROME_DEVTOOLS_MCP_NO_UPDATE_CHECKS = "1";
  };
}
