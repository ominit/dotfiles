if ! pacman -Qq paru >/dev/null; then
  sudo pacman -Sy paru
fi

if ! xargs -a packages paru -Qq >/dev/null; then
  xargs -a packages paru -Syyu --needed
else 
  paru -Syyu 
fi

cat flatpaks | xargs flatpak install

sh other_commands.sh

sh build_from_source.sh
