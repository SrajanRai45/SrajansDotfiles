#!/bin/sh

echo "ensuring uv package manager is installed"
sudo pacman -S --needed uv

echo "preparing install of pywal16"
sleep 1
uv tool install --upgrade git+https://github.com/eylles/pywal16.git
echo "installed pywal16"

echo "preparing install of pywalfox"
sleep 1
uv tool install --upgrade pywalfox
pywalfox install
echo "installed pywalfox"
