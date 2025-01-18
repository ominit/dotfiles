{
  pkgs,
  lib,
  ...
}: {
  home-manager.users."ominit".programs.librewolf = {
    enable = true;
    settings = {
      "middlemouse.paste" = false;
      "general.autoScroll" = true;
      "identity.fxaccounts.enabled" = true;
      "extensions.update.enabled" = true;
      "extensions.update.autoUpdateDefault" = true;
      "webgl.disabled" = false;
    };
    profiles."ominit" = {
      search = {
        default = "Brave";
        privateDefault = "Brave";
        force = true;
        engines = {
          "Brave" = {
            name = "Brave";
            description = "Brave Search: private, independent, open";
            queryCharset = "UTF-8";
            searchForm = "https://search.brave.com/search";
            iconURL = "https://cdn.search.brave.com/serp/v1/static/brand/eebf5f2ce06b0b0ee6bbd72d7e18621d4618b9663471d42463c692d019068072-brave-lion-favicon.png";
            urls = [
              {
                template = "https://search.brave.com/search";
                method = "GET";
                type = "text/html";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
              {
                template = "https://search.brave.com/api/suggest";
                method = "GET";
                type = "application/x-suggestions+json";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
          };
        };
      };
      # extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      #   ublock-origin
      #   sponsorblock
      # ]; // no need, login using firefox sync
    };
  };
}
