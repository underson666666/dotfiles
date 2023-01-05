#!/usr/bin/env bash
DIR="$( cd "$( dirname "$0" )" && pwd -P )"
echo "source $DIR/.bash_profile_additional" >> ~/.bash_profile
echo "source $DIR/.bashrc_additional" >> ~/.bashrc

source ~/.bash_profile
