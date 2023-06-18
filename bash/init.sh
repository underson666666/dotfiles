#!/usr/bin/env bash
DIR="$( cd "$( dirname "$0" )" && pwd -P )"


echo "" >> ~/.bash_profile
echo "#######################" >> ~/.bash_profile
echo "# additional settings #" >> ~/.bash_profile
echo "#######################" >> ~/.bash_profile
echo "source $DIR/.bash_profile_additional" >> ~/.bash_profile
echo "" >> ~/.bash_profile

echo "" >> ~/.bashrc
echo "#######################" >> ~/.bashrc
echo "# additional settings #" >> ~/.bashrc
echo "#######################" >> ~/.bashrc
echo "source $DIR/.bashrc_additional" >> ~/.bashrc
echo "" >> ~/.bashrc

source ~/.bash_profile
