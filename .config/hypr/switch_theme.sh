#! /usr/bin/env bash

HX_LIGHT='theme = "kaolin-light"'
HX_DARK='theme = "jetbrains_dark"'
TERM_LIGHT='onelight'
TERM_DARK='onedark'


if [[ $(dconf read /org/gnome/desktop/interface/color-scheme) == "'prefer-light'" ]]; then
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  sed -i "1c$HX_DARK" ~/.config/helix/config.toml
  sed -i "s/$TERM_LIGHT/$TERM_DARK/g" ~/.config/kitty/kitty.conf
else
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
  sed -i "1c$HX_LIGHT" ~/.config/helix/config.toml
  sed -i "s/$TERM_DARK/$TERM_LIGHT/g" ~/.config/kitty/kitty.conf
fi
