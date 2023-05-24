#!/bin/bash

#Variable - Path of provided file
filePath=$HOME/recyclebin/$1

#Variable - Original path of provided file
originalPath=$(grep ^"$1" $HOME/.restore.info | cut -d":" -f2)


#Function - Restore file and remove a line from .restore.info
function fMove(){
        mv $HOME/recyclebin/$1 $originalPath
        cat $HOME/.restore.info | grep -v ^"$1" > $HOME/.tempRestore.info
        mv $HOME/.tempRestore.info $HOME/.restore.info
}


#Test error conditions, restore file and remove info from .restore.info
#no filename provided
if [ $# -eq 0 ]
        then
                echo "restore: missing operand"
                exit 1
#file does not exist
elif [ ! -e $filePath ]
        then
                echo "restore: cannot restore '$1': no such file "
                exit 1
#file provided
else
#check if filename is in target directory. If yes, ask about overwriting.
        if [ -e $originalPath ]
                then
                        read -p "Do you want to overwrite? y/n " answer
                        case $answer in
                                y*|Y*)
                                        fMove $1
                                        exit 0;;
                                *)
                                        exit 1;;
                        esac
#if not, restore file
        else
                fMove $1
        fi
fi
