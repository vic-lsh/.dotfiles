#!/bin/sh

git config --global user.name vic-shihang-li
git config --global user.email 40274755+vic-shihang-li@users.noreply.github.com

# setup symlinks
ln -nfs $(pwd)/.config ~/.config
