#! /usr/bin/env bash

dirs=(
  helix
  hypr
  fish
)

for dir in ${dirs[@]}; do
  ln --symbolic -n /home/$USER/dotfiles/$dir /home/$USER/.config/$dir
done
