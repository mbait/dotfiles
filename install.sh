#!/bin/bash

set -e

cd dotfiles/

lnabs () {
  local src=$PWD/$1
  local dst=$2
  [ -d `dirname $dst` ] || mkdir -p $dst
  [ -L $dst ] && ln -svf $src $dst || ln -svb $src $dst
}

target=~/.Xresources
lnabs Xresources $target && xrdb -merge $target

for c in git i3; do
  mkdir -p ~/.config/$c && lnabs "$c"config ~/.config/$c/config
done

for c in bash_aliases bash_env bashrc tmux.conf toprc vimrc vim; do
  lnabs $c ~/.$c
done

target=~/.bashrc
lnabs bashrc $target && source $target

mkdir -p ~/bin
lnabs lesspipe ~/bin

for terminfo in /usr/share/terminfo/r/rxvt-unicode-256color; do
  if [ -r $terminfo ]; then
    mkdir -p ~/.terminfo/r/
    ln -svf $terminfo ~/.terminfo/r/
  fi
done

lnabs gpg-agent.conf ~/.gnupg/gpg-agent.conf
echo -n 'Reloading gpg-agent... '
gpg-connect-agent reloadagent /bye
