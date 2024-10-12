sudo pacman -Syyu

if ! pacman -Qq paru >/dev/null; then
  sudo pacman -Sy paru
fi

if ! cat packages | xargs paru -Qq >/dev/null; then
  cat packages | xargs paru -Syq --needed --noconfirm
fi

cat flatpaks | xargs flatpak install

sh other_commands.sh

sh build_from_source.sh
