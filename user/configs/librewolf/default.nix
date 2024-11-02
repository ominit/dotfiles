{
  pkgs,
  lib,
  ...
}: let
  bookmarks = import ./bookmarks.nix {inherit lib;};
  extensions = import ./extensions.nix;

  librewolf = pkgs.wrapFirefox pkgs.librewolf-unwrapped {
    inherit (pkgs.librewolf-unwrapped) extraPrefsFiles extraPoliciesFiles;
    wmClass = "Librewolf";
    # inherit nativeMessagingHosts;

    extraPrefs = ''
      pref("middlemouse.paste", false);
      pref("general.autoScroll", true);
      pref("identity.fxaccounts.enabled", true);
    '';

    extraPolicies = {
      Bookmarks = bookmarks;
      ExtensionSettings = extensions;
    };
  };
in {
  home.packages = [librewolf];
}
