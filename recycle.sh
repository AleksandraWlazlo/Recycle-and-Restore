#!/bin/bash


#Create recyclebin if it does not exist.
directory="$HOME/recyclebin"
if [ ! -d $directory ] ; then
        mkdir $HOME/recyclebin
fi


#Changing name of a file
function fChangeName (){
        file=$(basename $1)
        id=$(ls -i $1 | cut -d" " -f1)
        finalName=${file}"_"${id}
        echo $finalName
}


#Create an output redirection to .restore.info and move file to recyclebin
function fRedirectAndMove (){
        #Variables
        absolutePath=$(readlink -f $1)
        infoRestore=$(fChangeName $1)":"$absolutePath

        #Redirect output with a new name to .restore.info (filename with : and an absolute path)
        echo $infoRestore >> $HOME/.restore.info

        #Move a file with new name to recyclebin
        path=$HOME/recyclebin/$(fChangeName $1)
        mv $1 $path
}


#Apply options: -v to display a message 'removed $1', -i to ask for confirmation.
#Variables to getopts
vOption=false
iOption=false

#Change options to true if, they were selected.
while getopts :vi opt ; do
        case $opt in
                v)      vOption=true ;;
                i)      iOption=true ;;
                #If incorrect option provided display the offending option value and exit
                *)      echo "Invalid option provided: $OPTARG"
                        exit 1 ;;
        esac
done
shift $(($OPTIND -1))


#Test error conditions, process options, remove a file, add info to .restore.info
#no filename provided
if [ $# -eq 0 ] ; then
        echo "recycle: missing operand"
else
        #go through every argument
        while [ $# -gt 0 ] ; do
                #file does not exist - display a message
                if [ ! -e $1 ] ; then
                        echo "recycle: cannot remove '$1': No such file or directory "
                        shift
                        continue
                #directory name provided - display a message
                elif [ -d $1 ] ; then
                        echo "recycle: cannot remove ‘$1’: Is a directory"
                        shift
                        continue
                #recycle name provided - display a message
                elif [ $(basename $1) = "recycle" ] ; then
                        echo "Attempting to delete recycle - operation aborted."
                        shift
                        continue
                #file provided - process options and remove files
                else
                        #If -i provided, ask for confirmation to remove files
                        if $iOption ; then
                                read -p "recycle: remove regular empty file '$1'? " answer
                                #if answer is y or Y - remove file, otherwise continue
                                case $answer in
                                        y|Y)    ;;
                                        *)      shift
                                                continue;;
                                esac
                        fi
                        #if -v provided, display a message that confirms removing a file
                        if $vOption ; then
                                echo "removed '$1'"
                        fi
                        #Redirect info to .restore.info and move the file to recyclebin
                        fRedirectAndMove $1
                        shift
                fi
        done
fi

