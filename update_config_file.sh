#!/bin/bash

function print_error()
{
    test "$(uname)" == "Darwin" && { echo -e "\033[31merror: $1\033[0m" && return 0; }
    test "$(uname)" == "Darwin" || { echo -e "\e[31merror: $1\e[0m" && return 0; }
}

function print_warning()
{

    test "$(uname)" == "Darwin" && { echo -e "\033[33mwarning: $1\033[0m" && return 0; }
    test "$(uname)" == "Darwin" || { echo -e "\e[33mwarning: $1\e[0m" && return 0; }
}

function print_infor()
{

    test "$(uname)" == "Darwin" && { echo -e "\033[32minfor: $1\033[0m" && return 0; }
    test "$(uname)" == "Darwin" || { echo -e "\e[32minfor: $1\e[0m" && return 0; }
}

function print_result()
{
    if [ "$1" == "0" ];then
        print_infor "nothing to update from $HOSTNAME"
        return 0
    else
        print_infor "update $HOSTNAME config files !!"
        return 0
    fi
}

function upload_to_github()
{
    $git_utils pull .

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

    print_infor "git commit -m \"update file $comment from $USER@$HOSTNAME\"  ... "

    git commit -m "update file $comment from $USER@$HOSTNAME"

    git push -u $(git remote -v | grep "git@github.com" | sed -n 1p | awk '{print $1}') master
    
    if [ "$?" != "0" ];then 
        print_warning "try to git pull using ssh fail, try https" 
        origin_https=$(git remote -v  | grep git@github.com | sed -n 1p | awk '{print $2}' | sed 's%git@github.com:%https://github.com/%g') 
        git remote add origin_https $origin_https
        git push origin_https master
        git remote rm origin_https
    fi
}

function copy_files()
{
    from=$1
    to=$2

    test -f "$from" || { print_error "could not find file $from" && return 0; }
    test -f "$to" || { print_warning "could not find file $to"; }

    diff $from $to &> /dev/null
    if [ "$?" != "0" ];then
        print_infor "copy $from here ..." 
        cp -f "$from" "$to"
        return 1
    fi

    return 0
}

function copy_config_from_macosx()
{
    echo 
    print_infor "pull update from github ..."
    git pull  $(git remote -v | grep "github" | sed -n 1p | awk '{print $1}') master
    echo 

    local flag=0

    # generate vim plugin
    $git_utils clone ~/.vim/bundle &> /dev/null && \
    copy_files "$(ls -t /tmp/clone*.sh | head -n 1)" ./_vim_clone_plugin_$HOSTNAME.sh &&
    flag=$flag+$?

    copy_files ~/.bash_profile ./_bash_profile-$HOSTNAME 
    flag=$flag+$?

    copy_files ~/.bash_profile ./_zshrc-$HOSTNAME 
    flag=$flag+$?

    copy_files ~/.tmux.conf  ./_tmux.conf-$HOSTNAME 
    flag=$flag+$?

    copy_files ~/.vimrc  ./_vimrc-$HOSTNAME 
    flag=$flag+$?

    copy_files ~/.gitconfig  ./_gitconfig-$HOSTNAME 
    flag=$flag+$?

    copy_files ~/.ssh/config  ./_ssh_config-$HOSTNAME 
    flag=$flag+$?

    ls ~/.vim/bundle/ | sort -f > ./_vim_plugin_list-Huangs-MBP.txt

    print_result $flag

    upload_to_github

    return 0

}


function copy_config_from_cygwin()
{
    echo 
    print_infor "pull update from github ..."
    git pull  $(git remote -v | grep "github" | sed -n 1p | awk '{print $1}') master
    echo 

    local flag=0

    # make it compatiable between git-bash and cygwin-bash
    if [ "$shell" == "/usr/bin/bash" ];then
        dir=/cygdrive
    else
        dir=
    fi

    # generate vim plugin
    $git_utils clone $dir/d/vim/vimfiles/bundle &> /dev/null && \
    copy_files "$(ls -t /d/temp/clone*.sh | head -n 1)" ./_vim_clone_plugin_$HOSTNAME.sh
    let flag=$flag+$?

    copy_files $dir/d/Vim/_vimrc ./_vimrc-$HOSTNAME
    let flag=$flag+$?

    copy_files $dir/d/cygwin64/home/$USER/.tmux.conf ./_tmux.conf-$HOSTNAME
    let flag=$flag+$?

    copy_files $dir/d/cygwin64/home/mianb/.bash_profile ./_bash_profile-$HOSTNAME
    let flag=$flag+$?

    copy_files $dir/d/cygwin64/home/mianb/.gitconfig ./_gitconfig-$HOSTNAME
    let flag=$flag+$?

    copy_files $dir/d/Batch/_cvimrc ./_cvimrc-$HOSTNAME
    let flag=$flag+$?

    copy_files $dir/d/cwRsyncServer/rsyncd.conf ./rsyncd.conf-$HOSTNAME
    let flag=$flag+$?

    copy_files $dir/d/cygwin64/home/mianb/.ssh/config ./_ssh_config-$HOSTNAME
    let flag=$flag+$?

    print_result $flag

    upload_to_github
}

function copy_config_from_t430()
{
    echo 
    print_infor "pull update from github ..."
    git pull  $(git remote -v | grep "github" | sed -n 1p | awk '{print $1}') master
    echo 
    
    flag=0

    copy_files ~/.bashrc ./_bash_profile-$HOSTNAME
    flag=$?

    print_result $flag

    upload_to_github
}

function main()
{
    echo --------------------------------------------------------
    print_infor "Running Scripts $0 At $HOSTNAME !!"
    echo --------------------------------------------------------

    git_utils=../18-bash-utils/25_git_utils.sh
    test -f $git_utils  || { print_error "could not find $git_utils" && return 1; }

    # set working directory
    pushd $dir/d/documents/11-configs-from-github &> /dev/null

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

    popd &> /dev/null
}


main $*
