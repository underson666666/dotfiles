#!/usr/bin/env bash
git config --global init.defaultBranch main
git config --global core.editor vim
git config --global color.diff auto
git config --global color.status auto
git config --global diff.tool vimdiff
git config --global difftool.prompt false
git config --global merge.tool vimdiff
git config --global merge.conflictstyle diff3
git config --global mergetool.prompt false
