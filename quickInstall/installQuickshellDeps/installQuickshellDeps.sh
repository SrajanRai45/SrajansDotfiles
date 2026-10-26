#!/bin/sh

echo "preparing installation of quickshell system dependencies"
sleep 1
sudo pacman -S --needed brightnessctl pamixer otf-font-awesome wf-recorder qt6-declarative
echo "installed quickshell system dependencies"

echo "preparing installation of python build tools"
sleep 1
sudo pacman -S --needed python-setuptools
echo "installed python build tools"
