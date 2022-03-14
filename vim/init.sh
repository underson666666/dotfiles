#!/usr/bin/env bash

ORGDIR=$HOME/orig_vim_settings/
if [ ! -d $ORGDIR ]; then
    mkdir $ORGDIR
    targets=("$HOME/.vimrc" "$HOME/.vim/userautoload" "$HOME/.cheatsheet.md")
    for target in "${targets[@]}"
    do
        if [ -f $target ] || [ -d $target ] ; then
            if [ -L $target ] ; then
                unlink $target
            else
                mv $target $ORGDIR
            fi
        fi
    done
fi

if [ ! -d $HOME/.vim ] ; then
    mkdir $HOME/.vim
fi

ln -s `pwd`/.vimrc $HOME/.vimrc
ln -s `pwd`/.vim/userautoload $HOME/.vim/userautoload
ln -s `pwd`/.cheatsheet.md $HOME/.cheatsheet.md

# install vim-plug
if [ ! -d $HOME/.vim/autoload ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# install plugins
vim -c PlugInstall -c qa
