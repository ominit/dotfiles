#!/usr/bin/sh

SRC_PATH=~/build_from_source/

if ! [ -d $SRC_PATH ]; then
  mkdir $SRC_PATH
fi

pushd $SRC_PATH

# helix editor
if ! [ -d ./helix/ ]; then
  git clone https://github.com/helix-editor/helix.git
fi
pushd ./helix/
git pull
cargo install --path helix-term --locked
popd

popd
