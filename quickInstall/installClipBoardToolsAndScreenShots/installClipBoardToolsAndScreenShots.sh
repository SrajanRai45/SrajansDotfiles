#!/bin/sh

echo "preparing installation of clipboard tools"
sleep 1
sudo pacman -S --needed wl-clipboard cliphist fuzzel
echo "installed clipboard tools"

echo "preparing installation of screenshot tools"
sleep 1
sudo pacman -S --needed grim slurp swappy
echo "installed screenshot tools"
