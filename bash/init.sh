#!/usr/bin/env bash
cat .bash_profile_additional >> ~/.bash_profile
cat .bashrc_additional >> ~/.bashrc

source ~/.bash_profile
