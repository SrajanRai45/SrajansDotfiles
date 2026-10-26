#!/bin/sh

echo "Installing LaTeX essentials, build tools, and Zathura..."
sudo pacman -S --needed texlive-basic texlive-latex texlive-latexextra texlive-binextra zathura zathura-pdf-mupdf

echo "Installation complete! Remember to enable lang.tex in LazyVim."
