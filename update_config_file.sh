#!/bin/bash

function print_result()
{
    flag=$1
    if [ "$flag" == "1" ];then
        echo update $HOSTNAME documents !!
        return 0
    else
        echo nothing to update from $HOSTNAME
        return 0
    fi
}

function upload_to_github()
{

    check=`git status | grep "modified:"`

    files=`echo $check | awk -F":" '{print $2}'`

    if [ -z "$files" ];then
        echo "nothing to git commit"
        return 0
    fi

    for file in $files
    do
        echo git add $file ...
        comment=$file $comment
        git add $file
    done

    echo git commit -m "update file $comment from $HOSTNAME"  ...

    git commit -m "update file $comment from $HOSTNAME"

    git push -u git@github.com:deepblue0755/documents.git master
    
}

function copy_files()
{
    from=$1
    to=$2

    if [ ! -f $fome ];then
        echo "error ,there's no such file $from !!"
        return 0
    fi

    diff $from $to 
    if [ "$?" != "0" ];then
        cp -f "$from" "$to"
        return 1
    fi

    return 0
}

function copy_config_from_macosx()
{
    echo 
    echo pull update from github ...
    git pull origin master
    echo 

    flag=0

    copy_files ~/.bash_profile ./_bash_profile-$HOSTNAME 
    flag=$?

    copy_files ~/.tmux.conf  ./_tmux.conf-$HOSTNAME 
    flag=$?

    print_result $flag

    upload_to_github

    return 0

}


function copy_config_from_cygwin()
{
    flag=0

    if [ "$shell" == "/usr/bin/bash" ];then
        dir=/cygdrive

    else
        dir=
    fi


    diff $dir/d/Vim/_vimrc ./_vimrc-$HOSTNAME

    if [ $? != 0 ];then
        echo copy vim _vimrc ...
        cp $dir/d/Vim/_vimrc ./_vimrc-$HOSTNAME
        flag=1
    fi

    diff $dir/d/cygwin64/home/$USER/.tmux.conf ./_tmux.conf-$HOSTNAME

    if [  $? != 0 ];then
        echo copy tmux .tmux.conf ...
        cp $dir/d/cygwin64/home/$USER/.tmux.conf ./_tmux.conf-$HOSTNAME
        flag=1
    fi

    diff $dir/d/cygwin64/home/mianb/.bash_profile ./_bash_profile-$HOSTNAME

    if [  $? != 0 ];then
        echo copy cygwin64 .bash_profile ...
        cp  $dir/d/cygwin64/home/mianb/.bash_profile ./_bash_profile-$HOSTNAME
        flag=1
    fi

    diff $dir/d/cygwin64/home/mianb/.gitconfig ./_gitconfig-$HOSTNAME

    if [  $? != 0 ];then
        echo copy cygwin64 .gitconfig ...
        cp  $dir/d/cygwin64/home/mianb/.gitconfig ./_gitconfig-$HOSTNAME
        flag=1
    fi

    diff $dir/d/Batch/_cvimrc ./_cvimrc-$HOSTNAME

    if [  $? != 0 ];then
        echo copy _cvimrc ...
        cp  $dir/d/Batch/_cvimrc ./_cvimrc-$HOSTNAME
        flag=1
    fi

    if [ "$flag" == "0" ];then
        echo no update from $HOSTNAME
    fi
}

function main()
{
    echo --------------------------------------------------------
    echo Running Scripts $0 At $HOSTNAME !!
    echo --------------------------------------------------------

    case $HOSTNAME in 

        Gigabyte-Brix)
            copy_config_from_cygwin
        ;;

        Huangs-T580)
            copy_config_from_cygwin
        ;;

        Huangs-MBP)
            copy_config_from_macosx
        ;;
    esac
}


main
