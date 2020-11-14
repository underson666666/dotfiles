#!/bin/sh
ln -s `pwd`/.vimrc ~/.vimrc
ln -s `pwd`/.cheatsheet ~/.cheatsheet
ln -s `pwd`/.vim ~/.vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -c PlugInstall -c qa
