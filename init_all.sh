#!/usr/bin/env bash                                                                                                                                                                     
currentdir=`pwd`                                                                                                                                                                  
                                                                                                                                                                                  
dirs[0]="bash"                                                                                                                                                                    
dirs[1]="git"                                                                                                                                                                     
dirs[2]="tmux"                                                                                                                                                                    
dirs[3]="vim"                                                                                                                                                                     
                                                                                                                                                                                  
for d in ${dirs[@]}                                                                                                                                                               
do                                                                                                                                                                                
    cd $d                                                                                                                                                                         
    ./init.sh                                                                                                                                                                     
    cd $currentdir                                                                                                                                                                
done
