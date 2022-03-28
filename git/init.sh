#!/usr/bin/env bash
target=~/.gitconfig
if [ ! -e $target ] || ! grep -q diff $target ; then
    cat .gitconfig_addtional >> ~/.gitconfig
fi
