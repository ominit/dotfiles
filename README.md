<h1 align=center>dotfiles</h1>

<div align=center>

[![garnix CI](https://img.shields.io/endpoint?url=https%3A%2F%2Fgarnix.io%2Fapi%2Fbadges%2Fominit%2Fdotfiles%3Fbranch%3Dmain&style=for-the-badge&labelColor=101418&color=a1efd3)](https://garnix.io/repo/ominit/dotfiles)
![GitHub last commit](https://img.shields.io/github/last-commit/ominit/dotfiles?style=for-the-badge&labelColor=101418&color=ffe9aa)
![GitHub Repo stars](https://img.shields.io/github/stars/ominit/dotfiles?style=for-the-badge&labelColor=101418&color=d4bfff)
![NIXOS Badge](https://img.shields.io/badge/NIXOS-wink?style=for-the-badge&logo=nixos&labelColor=101418&color=91ddff)

</div>

## Structure
- [`hosts`](hosts) configuration per host
	- [`eientei`](hosts/eientei) T480 Thinkpad laptop - Daily driver for notes and programming
	- [`makai`](hosts/makai) HP Pavilion Gaming Desktop - Homelab server - 魔界: where dæmons live
	- [`wsl`](hosts/wsl) Windows Subsystem for Linux
- [`libEx`](libEx) extra lib commands
- [`modules`](modules) custom modules consumed by hosts
	- [`programs`](modules/programs) my program configurations
- [`parts`](parts) [flake-parts](https://github.com/hercules-ci/flake-parts)
	- [`treefmt`](parts/treefmt.nix) treefmt - fmt check and `nix fmt`
- [`secrets`](secrets) sops-nix secrets

## Installation Instructions (for myself)
boot using nix installer
```
# set password
passwd
```
ssh into machine, rest is headless
```
git clone https://github.com/ominit/dotfiles.git
```
```
# run disko, make sure to change disko file
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount /home/nixos/dotfiles/hosts/hostname/disko.nix
```
setup sops key
```
sudo nixos-install --flake github:ominit/dotfiles#hostname
```

## Extra
[firefox theme](https://color.firefox.com/?theme=XQAAAAJDBAAAAAAAAABBqYhm849SCicxcUcPX38oKRicm6da8pFtMcQD6nrb3hVaZ4ZDQ499FUcwBYu_qLKyYPM65OP_BKJnRyTWOztZCf_gdf3bl23-Qu_hT6RzR_NrESOtjjKyf3_683nvhh8S62Tor-v04OptN9h9c8NJfFqPcdSvGsPmLizW7pgQF0_ebk0RGu8xGE48lM32r9138dqm4pOl5h0uYZiujSZlo7di0-29e-zlpPh21tJ4fEtwrCD_CpAMQcvy8kN2gOR3Sw-VgyIxOMBLGKjRZYcKoyA5VMrlF4NpOaeA4GOSVNq5zoOW6sD5xGRyhRl6BQMl7Nq7dpA_bhfhKSa5IUBrvZ33DghwfiDrN2nlTqn-GpAdr_EoGV2dFYPrLpwSWDo_X_Uo1LHuy9wIv2x15ufs42S2EBYWr1a_TJyJKn42AiBLJ8LZtyX860lW0NeiLa3noUSwdbCmD9NNNhLvh0_d6_712tg5K2Y8FjkHssbwiIEkiewEgNm2mzyEufIcHfQNJxo6c3NmotNqeE8ZfCLMpWivmf-n6diBbu2yUx8vGUUrj58zKzgMWp16YwzDTY4iu4a44D6j8qMzIngQtKLO_-ncm-I) (manual install)

### Future Host Names:
These are based on locations from the Touhou Project.
- hakurei
- kourindou
- koumakan
- gensokyo
- geidontei
- hakugyokurou
- mayohiga
- moriya
- muenzuka
- mugenkan
- myouren
- senkai
- jigoku

## Credits
[@NotAShelf/nyx](https://github.com/NotAShelf/nyx)
