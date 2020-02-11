#!/bin/bash

function print_error()
{
    echo -e "\e[31merror: $1\e[0m"
}

function print_warning()
{

    echo -e "\e[33mwarning: $1\e[0m"
}

function print_infor()
{

    echo -e "\e[32minfor: $1\e[0m"
}

function print_result()
{
    flag=$1
    if [ "$flag" == "1" ];then
        print_infor "update $HOSTNAME documents !!"
        return 0
    else
        print_infor "nothing to update from $HOSTNAME"
        return 0
    fi
}

function upload_to_github()
{

    files=`git status | grep "modified:" | awk -F":" '{print $2}'`

    if [ -z "$files" ];then
        print_infor "nothing to git commit"
        return 0
    fi

    for file in $files
    do
        if [ -f "$file" ];then
            print_infor "git add $file ..."
            comment="$comment $file"
            git add "$file"
        fi
    done

    print_infor "git commit -m \"update file $comment from $USER @ $HOSTNAME\"  ... "

    git commit -m "update file $comment from $USER @ $HOSTNAME"

    git push -u $(git remote | sed -n 1p) master
    
}

function copy_files()
{
    from=$1
    to=$2

    if [ ! -f $fome ];then
        print_error "there's no such file $from !!"
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
    print_infor "pull update from github ..."
    git pull origin master
    echo 

    flag=0

    copy_files ~/.bash_profile ./_bash_profile-$HOSTNAME 
    flag=$?

    copy_files ~/.tmux.conf  ./_tmux.conf-$HOSTNAME 
    flag=$?

    copy_files ~/.vimrc  ./_vimrc-$HOSTNAME 
    flag=$?

    ls ~/.vim/bundle/ | sort -f > ./_vim_plugin_list-Huangs-MBP.txt

    print_result $flag

    upload_to_github

    return 0

}


function copy_config_from_cygwin()
{
    echo 
    print_infor "pull update from github ..."
    git pull 
    echo 

    flag=0

    if [ "$shell" == "/usr/bin/bash" ];then
        dir=/cygdrive

    else
        dir=
    fi


    diff $dir/d/Vim/_vimrc ./_vimrc-$HOSTNAME

    if [ $? != 0 ];then
        print_infor "copy vim _vimrc ..."
        cp $dir/d/Vim/_vimrc ./_vimrc-$HOSTNAME
        flag=1
    fi

    ls $dir/d/Vim/vimfiles/bundle | sort > ./_vim_plugin_list-$HOSTNAME.txt 

    diff $dir/d/cygwin64/home/$USER/.tmux.conf ./_tmux.conf-$HOSTNAME

    if [  $? != 0 ];then
        print_infor "copy tmux .tmux.conf ..."
        cp $dir/d/cygwin64/home/$USER/.tmux.conf ./_tmux.conf-$HOSTNAME
        flag=1
    fi

    diff $dir/d/cygwin64/home/mianb/.bash_profile ./_bash_profile-$HOSTNAME

    if [  $? != 0 ];then
        print_infor "copy cygwin64 .bash_profile ..."
        cp  $dir/d/cygwin64/home/mianb/.bash_profile ./_bash_profile-$HOSTNAME
        flag=1
    fi

    diff $dir/d/cygwin64/home/mianb/.gitconfig ./_gitconfig-$HOSTNAME

    if [  $? != 0 ];then
        print_infor "copy cygwin64 .gitconfig ..."
        cp  $dir/d/cygwin64/home/mianb/.gitconfig ./_gitconfig-$HOSTNAME
        flag=1
    fi

    diff $dir/d/Batch/_cvimrc ./_cvimrc-$HOSTNAME

    if [  $? != 0 ];then
        print_infor "copy _cvimrc ..." 
        cp  $dir/d/Batch/_cvimrc ./_cvimrc-$HOSTNAME
        flag=1
    fi

    print_result $flag

    upload_to_github
}

function copy_config_from_t430()
{
    echo 
    print_infor "pull update from github ..."
    git pull 
    echo 
    
    flag=0

    diff ~/.bashrc ./_bash_profile-$HOSTNAME

    if [  $? != 0 ];then
        print_infor "copy $HOME/.bashrc $PWD ..."
        cp  $HOME/.bashrc ./_bash_profile-$HOSTNAME
        flag=1
    fi

    print_result $flag

    upload_to_github
}

function main()
{
    echo --------------------------------------------------------
    print_infor "Running Scripts $0 At $HOSTNAME !!"
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
        t430)
            copy_config_from_t430
        ;;
    esac
}


main $*
