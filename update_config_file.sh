#!/bin/bash

function copy_config_from_macosx()
{
    diff ~/.bash_profile ./_bash_profile-$HOSTNAME
    flag=0

    if [  $? != 0 ];then
        echo copy MacOSx .bash_profile ...
        cp  ~/.bash_profile ./_bash_profile-$HOSTNAME
        flag=1
    fi

    if [ $flag = 0 ];then
        echo nothing to update from MacOSx
    fi

    return 0

}


function copy_config_from_cygwin()
{
    if [ "$shell" == "/usr/bin/bash" ];then
        dir=/cygdrive

    else
        dir=
    fi


    diff $dir/d/Vim/_vimrc ./_vimrc-$HOSTNAME

    if [ $? != 0 ];then
        echo copy vim _vimrc ...
        cp $dir/d/Vim/_vimrc ./_vimrc-$HOSTNAME
    fi

    diff $dir/d/cygwin64/home/$USER/.tmux.conf ./_tmux.conf-$HOSTNAME

    if [  $? != 0 ];then
        echo copy tmux .tmux.conf ...
        cp $dir/d/cygwin64/home/$USER/.tmux.conf ./_tmux.conf-$HOSTNAME
    fi

    diff $dir/d/cygwin64/home/mianb/.bash_profile ./_bash_profile-$HOSTNAME

    if [  $? != 0 ];then
        echo copy cygwin64 .bash_profile ...
        cp  $dir/d/cygwin64/home/mianb/.bash_profile ./_bash_profile-$HOSTNAME
    fi

    diff $dir/d/cygwin64/home/mianb/.gitconfig ./_gitconfig-$HOSTNAME

    if [  $? != 0 ];then
        echo copy cygwin64 .gitconfig ...
        cp  $dir/d/cygwin64/home/mianb/.gitconfig ./_gitconfig-$HOSTNAME
    fi

    diff $dir/d/Batch/_cvimrc ./_cvimrc-$HOSTNAME

    if [  $? != 0 ];then
        echo copy _cvimrc ...
        cp  $dir/d/Batch/_cvimrc ./_cvimrc-$HOSTNAME
    fi
}

function main()
{
    echo Running Scripts At $HOSTNAME !!
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
