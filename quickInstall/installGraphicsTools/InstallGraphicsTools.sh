#!/bin/sh

echo "preparing installation of mangohud and vulkan-tools"
sleep 1
sudo pacman -S --needed --noconfirm mangohud vulkan-tools
echo "installed mangohud and vulkan-tools"

echo "preparing installation of ryzenadj from AUR"
sleep 1
if command -v yay >/dev/null 2>&1; then
  yay -S --needed --noconfirm ryzenadj-git
  echo "installed ryzenadj via yay"
elif command -v paru >/dev/null 2>&1; then
  paru -S --needed --noconfirm ryzenadj-git
  echo "installed ryzenadj via paru"
else
  echo "Notice: Neither yay nor paru was found. Please install ryzenadj-git manually from the AUR."
fi
