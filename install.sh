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

mkdir -p ~/.config/git/
lnabs gitconfig	~/.config/git/config
mkdir -p ~/.config/i3/ && lnabs i3config ~/.config/i3/config

target=~/.bashrc
lnabs bash_aliases ~/.bash_aliases
lnabs bash_env ~/.bash_env
lnabs bashrc $target && source $target

lnabs tmux.conf ~/.tmux.conf
lnabs toprc ~/.toprc
lnabs vimrc ~/.vimrc
lnabs vim ~/.vim

mkdir -p ~/bin
lnabs lesspipe ~/bin

for terminfo in /usr/share/terminfo/r/rxvt-unicode-256color; do
  if [ -r $terminfo ]; then
    mkdir -p ~/.terminfo/r/
    ln -svf $terminfo ~/.terminfo/r/
  fi
done

lnabs gpg-agent.conf ~/.gnupg/gpg-agent.conf
echo 'Reloading gpg-agent... '
gpg-connect-agent reloadagent /bye
