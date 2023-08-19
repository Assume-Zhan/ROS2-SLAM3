#!/bin/fish

set -U fish_color_command green
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
fisher install IlanCosman/tide@v5
printf "2122112222121y" | tide configure
fisher install andreiborisov/sponge
fisher install jorgebucaran/autopair.fish
fisher install edc/bass