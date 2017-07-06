#!/bin/bash

set -e

cd dotfiles/

lnabs () {
  local src=$PWD/$1
  local dst=$2
  [ -d `dirname $dst` ] || mkdir -p $dst
  [ -L $dst ] && ln -Tfsv $src $dst || ln -Tbsv $src $dst
}

for config in \
  git         \
  i3;
do
  mkdir -vp ~/.config/$config &&
    lnabs ${config}config ~/.config/$config/config
done

for config in  \
  Xresources   \
  bash_aliases \
  bash_env     \
  bashrc       \
  devscripts   \
  tmux.conf    \
  toprc        \
  vimrc        \
  vim;
do
  lnabs $config ~/.$config
done

lnabs bin ~/bin

xrdb -merge ~/.Xresources
source ~/.bashrc

for terminfo in                                \
  /usr/share/terminfo/r/rxvt-unicode-256color;
do
  if [ -r $terminfo ]; then
    mkdir -p ~/.terminfo/r/
    ln -svf $terminfo ~/.terminfo/r/
  fi
done

lnabs gpg-agent.conf ~/.gnupg/gpg-agent.conf
echo -n 'Reloading gpg-agent... '
gpg-connect-agent reloadagent /bye

source ~/.bashrc
