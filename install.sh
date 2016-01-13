#!/bin/bash

set -e


cd dotfiles/

lnabs () {
  local src=$PWD/$1
  local dst=$2
  [ -L $dst ] && ln -svf $src $dst || ln -svb $src $dst
}

target=~/.Xresources
lnabs Xresources $target && xrdb -merge $target

mkdir -p ~/.config/git/
lnabs gitconfig	~/.config/git/config
mkdir -p ~/.config/i3/ && lnabs i3config ~/.config/i3/config

target=~/.bashrc
lnabs bashrc $target && source $target

lnabs vimrc ~/.vimrc
