#!/bin/sh

ORGDIR=orig_vim_settings/
mkdir $ORGDIR
if [ -f ~/.vimrc ] ; then
    mv ~/.vimrc $ORGDIR
fi
if [ -d ~/.vim ] ; then
    mv ~/.vim $ORGDIR
fi
if [ -d ~/.cheatsheet.md ] ; then
    mv ~/.cheatsheet.md $ORGDIR
fi

ln -s `pwd`/.vim $HOME/.vim
ln -s `pwd`/.vimrc $HOME/.vimrc
ln -s `pwd`/.cheatsheet.md $HOME/.cheatsheet.md

# install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# install plugins
vim -c PlugInstall -c qa
