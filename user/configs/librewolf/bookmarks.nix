{lib}: let
  prefixes = ["https://" "http://"];
  removePrefixes = url: lib.foldr (prefix: str: lib.strings.removePrefix prefix str) url prefixes;
  extractDomainName = url: lib.lists.head (lib.strings.split "/" (removePrefixes url));
  getFavicon = url: "https://icon.horse/icon/${extractDomainName url}";
  addFavicon = attrset: attrset // {"Favicon" = getFavicon attrset."URL";};

  bookmarks = [
    {
      "Title" = "sg";
      "URL" = "https://steamgifts.com";
      "Placement" = "toolbar";
    }
  ];
in
  builtins.map addFavicon bookmarks
