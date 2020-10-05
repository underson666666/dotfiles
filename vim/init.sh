#!/bin/sh
ln -s $HOME/.vimrc .vimrc
ln -s $HOME/.cheatsheet .cheatsheet
ln -s $HOME/.vim .vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
