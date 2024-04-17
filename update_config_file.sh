#!/bin/bash
#----------------------------------------------------------------------
# Script: restore_rootfs.sh
# Version: 1.0
# Author: mianb.huang@hotmail.com
# Date: 2024-04-17
# Description:  auto backup my configuration files from various machine
# Usage: ./update_config_file.sh
#----------------------------------------------------------------------

if [ -t 1 ];then
    if [[ "$(uname)" == "Darwin" ]];then
        # TO BE UPDATED IN MACOS
        GREEN="\033[0;32m"
        RED="\033[0;31m"
        YELLOW="\033[0;33m"
        NORMAL="\033[0m"
    else
        GREEN="\033[0;32m"
        RED="\033[0;31m"
        YELLOW="\033[0;33m"
        NORMAL="\033[0m"
    fi
else
    GREEN=""
    RED=""
    NORMAL=""
fi

cpac_backup_folder=./01-cpac-server-at-googoltech
cpac_backup_files=(
    ~/.bashrc:${cpac_backup_folder}/_bash_profile-cpac
    ~/.vimrc:${cpac_backup_folder}/_vimrc-cpac
    # the following is a list of gitlab-ce configuration file
    /etc/gitlab/gitlab-secrets.json                             :${cpac_backup_folder}/etc-gitlab-cpac/gitlab-secrets.json                                  
    /etc/gitlab/gitlab.rb.02.bak                                :${cpac_backup_folder}/etc-gitlab-cpac/gitlab.rb.02.bak
    /etc/gitlab/ssl/192.168.212.30.crt                          :${cpac_backup_folder}/etc-gitlab-cpac/ssl/192.168.212.30.crt
    /etc/gitlab/ssl/192.168.212.30.key                          :${cpac_backup_folder}/etc-gitlab-cpac/ssl/192.168.212.30.key
    /etc/gitlab/ssl/192.168.212.30.key-staging                  :${cpac_backup_folder}/etc-gitlab-cpac/ssl/192.168.212.30.key-staging
    /etc/gitlab/trusted-certs/192.168.212.30.crt                :${cpac_backup_folder}/etc-gitlab-cpac/trusted-certs/192.168.212.30.crt
    /etc/gitlab/gitlab/gitlab-secrets.json                      :${cpac_backup_folder}/etc-gitlab-cpac/gitlab/gitlab-secrets.json
    /etc/gitlab/gitlab/gitlab.rb.02.bak                         :${cpac_backup_folder}/etc-gitlab-cpac/gitlab/gitlab.rb.02.bak
    /etc/gitlab/gitlab/ssl/192.168.212.30.crt                   :${cpac_backup_folder}/etc-gitlab-cpac/gitlab/ssl/192.168.212.30.crt
    /etc/gitlab/gitlab/ssl/192.168.212.30.key                   :${cpac_backup_folder}/etc-gitlab-cpac/gitlab/ssl/192.168.212.30.key
    /etc/gitlab/gitlab/ssl/192.168.212.30.key-staging           :${cpac_backup_folder}/etc-gitlab-cpac/gitlab/ssl/192.168.212.30.key-staging
    /etc/gitlab/gitlab/trusted-certs/192.168.212.30.crt         :${cpac_backup_folder}/etc-gitlab-cpac/gitlab/trusted-certs/192.168.212.30.crt
    /etc/gitlab/gitlab/gitlab.rb                                :${cpac_backup_folder}/etc-gitlab-cpac/gitlab/gitlab.rb
    /etc/gitlab/gitlab/gitlab.rb.bak                            :${cpac_backup_folder}/etc-gitlab-cpac/gitlab/gitlab.rb.bak
    /etc/gitlab/gitlab.rb                                       :${cpac_backup_folder}/etc-gitlab-cpac/gitlab.rb
    /etc/gitlab/gitlab.rb.bak                                   :${cpac_backup_folder}/etc-gitlab-cpac/gitlab.rb.bak
    /etc/gitlab-runner/config.toml                              :${cpac_backup_folder}/etc-gitlab-runner-cpac/config.toml
    /etc/gitlab-runner/gitlab-runner/config.toml                :${cpac_backup_folder}/etc-gitlab-runner-cpac/gitlab-runner/config.toml
)


function print_infor()
{
	echo -e "${GREEN}INFO: $*${NORMAL}"
	return 0
}

function print_error()
{
	echo -e "${RED}ERROR: $*${NORMAL}"
	return 0
}

function print_warning()
{
	echo -e "${YELLOW}WARNING: $*${NORMAL}"
	return 0
}

function err_exit()
{
    print_error "$*"
    exit 1
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

    files=$(git status | grep "modified:" | awk -F":" '{print $2}')

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
        git remote add origin_https "$origin_https"
        git push origin_https master
        git remote rm origin_https
    fi
}

function copy_files()
{
    from="$1"
    to="$2"

    test -f "$from" || { print_error "could not find file $from" && return 0; }
    test -f "$to" || { print_warning "could not find file $to"; }

    if ! sudo diff "$from" "$to" &> /dev/null;then
        print_infor "copy $from here ..." 
        sudo cp -fv "$from" "$to"
    else
        print_infor "no difference had been found between ${source} and ${backup}, skip it"
        return 0
    fi

    return 0
}

function backup_files()
{
    local flag=0
    files=$1

    if [[ ${#files[@]} -eq 0 ]];then
        print_error "array $files is empty"
        return 1
    fi

    echo 
    print_infor "pull update from $(git remote -v | grep -m 1 "github"  | awk '{print $2}') ..."
    git pull  "$(git remote -v | grep -m 1 "github"  | awk '{print $2}')" master
    echo 

    for file_pair in "${files[@]}";
    do
        IFS=':' read -r source backup <<< "${file_pair}"
        print_infor "try to backup file ${source} to ${backup}"
        copy_files "${source}" "${backup}"
        flag=$flag+$?
    done

    print_result $flag
    upload_to_github
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

    copy_files $dir/d/cwRsyncServer/rsyncd.conf ./rsyncd.conf-$HOSTNAME
    let flag=$flag+$?

    copy_files $dir/d/cygwin64/home/mianb/.ssh/config ./_ssh_config-$HOSTNAME
    let flag=$flag+$?

    copy_files $dir/C/Users/mianb/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1 Microsoft.PowerShell_profile-$HOSTNAME.ps1
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
    flag=$flag+$?

    copy_files ~/.vimrc ./_vimrc-$HOSTNAME
    flag=$flag+$?

    print_result $flag

    upload_to_github
}

function copy_config_from_cpac_server()
{
    backup_files cpac_backup_files

    # copy_files ~/.bashrc ./_bash_profile-$HOSTNAME
    # flag=$flag+$?

    # copy_files ~/.vimrc ./_vimrc-$HOSTNAME
    # flag=$flag+$?

    # sudo cp -frv /etc/gitlab/ ./etc-gitlab-$HOSTNAME
    # sudo chown -R 1001:1001 ./etc-gitlab-$HOSTNAME
    # flag=$flag+$?

    # sudo cp -frv /etc/gitlab-runner ./etc-gitlab-runner-$HOSTNAME
    # sudo chown -R 1001:1001 ./etc-gitlab-runner-$HOSTNAME
    # flag=$flag+$?

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
        cpac)
            copy_config_from_cpac_server
        ;;
    esac

    popd &> /dev/null
}


main "$@"
