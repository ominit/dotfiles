# dotfiles
My NixOS configuration

# organization
### helperLib
- small library for system and home creation, used in flake.nix
### hosts
- configuration per host
### programModules
- wrapper around programs with my configuration setup, in host config: `program.enable = true;`
### vars.nix
- global flake variables

# hosts
laptop - Asus Zenbook Pro 14 OLED laptop
desktop - HP Pavillion Gaming desktop
wsl - for windows
eientei - T480 Thinkpad laptop
hakurei - Raspberry Pi 4B headless server

### potential host names:
kourindou
koumakan (sdm)
gensokyo
geidontei
hakugyokurou
makai
mayohiga
moriya
muenzuka
mugenkan
myouren
senkai
jigoku

[firefox theme](https://color.firefox.com/?theme=XQAAAAJDBAAAAAAAAABBqYhm849SCicxcUcPX38oKRicm6da8pFtMcQD6nrb3hVaZ4ZDQ499FUcwBYu_qLKyYPM65OP_BKJnRyTWOztZCf_gdf3bl23-Qu_hT6RzR_NrESOtjjKyf3_683nvhh8S62Tor-v04OptN9h9c8NJfFqPcdSvGsPmLizW7pgQF0_ebk0RGu8xGE48lM32r9138dqm4pOl5h0uYZiujSZlo7di0-29e-zlpPh21tJ4fEtwrCD_CpAMQcvy8kN2gOR3Sw-VgyIxOMBLGKjRZYcKoyA5VMrlF4NpOaeA4GOSVNq5zoOW6sD5xGRyhRl6BQMl7Nq7dpA_bhfhKSa5IUBrvZ33DghwfiDrN2nlTqn-GpAdr_EoGV2dFYPrLpwSWDo_X_Uo1LHuy9wIv2x15ufs42S2EBYWr1a_TJyJKn42AiBLJ8LZtyX860lW0NeiLa3noUSwdbCmD9NNNhLvh0_d6_712tg5K2Y8FjkHssbwiIEkiewEgNm2mzyEufIcHfQNJxo6c3NmotNqeE8ZfCLMpWivmf-n6diBbu2yUx8vGUUrj58zKzgMWp16YwzDTY4iu4a44D6j8qMzIngQtKLO_-ncm-I) (manual install)
