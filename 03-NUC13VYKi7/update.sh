#!/bin/bash

if [ -t 1 ];then
    GREEN="\033[0;32m"
    RED="\033[0;31m"
    YELLOW="\033[0;33m"
    NORMAL="\033[0m"
else
    GREEN=""
    RED=""
    NORMAL=""
fi

function PINFO() {
    echo  -e "${GREEN}INFO ($(basename $0):$BASH_LINENO): $* ${NORMAL}"
    return 0
}

function PERROR() {
    echo  -e "${RED}ERROR ($(basename $0):$BASH_LINENO): $* ${NORMAL}"
    return 0
}

function PWARN() {
    echo  -e "${YELLOW}WARN ($BASH_LINENO): $* ${NORMAL}"
    return 0
}

function list_vim_plugins()
{
    pushd /home/$(id -nu 1000)/.vim/bundle/ &>/dev/null || exit 1

    for fd in $(find ./ -maxdepth 1 -type d | grep -v "\./$")
    do
        pushd $fd &>/dev/null || exit 1
            git remote -v | grep origin | sed -n 1p | sort | awk '{ print $2 }'
        popd &>/dev/null || exit 1
    done
    popd &>/dev/null || exit 1
}

function autocommit()
{
    if ! git rev-parse --is-inside-work-tree &>/dev/null;then
        echo not a git repo
        return 1
    fi

    if ! git status | grep -q modified;then
        if ! git status | grep -q "new file";then
            echo "no modification or new file found in this repo"
            return 1
        fi
    fi

    echo "git pull ..."
    if git pull; then
       echo "successfully git pull"
    else
       echo "failed to git pull"
       return 1
    fi

    local commit_string=""
   
    if [[ $(git status | grep -c modified) -gt 1 ]];then
        files_list=$(git status | grep modified | awk -F: '{ print $2 }' | tr '\n' ',' | sed 's/^\s*//' | sed 's/  / /g')
        commit_string="UPDATE: Refactor $files_list from $HOSTNAME"
    elif [[  $(git status | grep -c modified) -eq 1  ]];then
        files_list=$(git status | grep modified | awk -F: '{ print $2 }' | sed 's/^\s*//' | sed 's/  / /g')
        commit_string="UPDATE: Refactor $files_list from $HOSTNAME"
    else
        :
    fi

    if [[ $(git status | grep -c "new file") -gt 1 ]];then
        files_list=$(git status | grep "new file" | awk -F: '{ print $2 }' | tr '\n' ',' | sed 's/^\s*//' | sed 's/  / /g')
        if [[ -n "$commit_string" ]];then
            commit_string="${commit_string}"$'\n'"NEW: Create new script $files_list from $HOSTNAME"
        else
            commit_string="NEW: Create new script $files_list from $HOSTNAME"
        fi
    elif [[ $(git status | grep -c "new file") -eq 1 ]];then
        files_list=$(git status | grep "new file" | awk -F: '{ print $2 }' | sed 's/^\s*//' | sed 's/  / /g')
        if [[ -n "$commit_string" ]];then
            commit_string="${commit_string}"$'\n'"NEW: Create new script $files_list from $HOSTNAME" 
        else
            commit_string="NEW: Create new script $files_list from $HOSTNAME"
        fi
    else
        :
    fi

    git commit -am "${commit_string}"

    echo "git push ..."
    if git remote | xargs -L1 git push ;then
       echo "successfully git push"
       return 0
    else
       echo "failed to git push"
       return 1
    fi
}


workdir="/home/$(id -nu 1000)/documents/11-configs-from-github/03-NUC13VYKi7/"

if [[ ! -d "${workdir}" ]];then
    PERROR "can not find work directory ${workdir}"
    exit 1
fi

pushd "${workdir}" &>/dev/null || exit 1
PINFO "git pull ..."
if ! git pull &>/dev/null;then
    PERROR "git pull failed"
else
    PINFO "successfully git pull"
fi
popd &>/dev/null || exit 1


PINFO "check if _bashrc need to updated"
if diff -q ${workdir}/_bashrc /home/$(id -nu 1000)/.bashrc;then
    PINFO "no need to update _bashrc ..."
else
    PINFO "update _bashrc ..."
    cp -fv /home/$(id -nu 1000)/.bashrc _bashrc
fi


if ! diff -q <(dpkg -l) ${workdir}/dpkg-lists.txt;then
    PINFO "dpkg -l > ${workdir}/dpkg-lists.txt"
    dpkg -l > "${workdir}/dpkg-lists.txt"
else
    PINFO "no need to update dpkg list"
fi

if ! diff -q <(apt list --installed) ${workdir}/deb-packages-list.txt;then
    PINFO "apt list --installed > ${workdir}/deb-packages-list.txt ..."
    apt list --installed > "${workdir}/deb-packages-list.txt"
else
    PINFO "no need to update apt installed list"
fi

if ! diff -q <(list_vim_plugins | sort) "${workdir}/vim_plugin_git_repo.txt";then
PINFO "update vim plugin list ..."
    truncate -s 0 "${workdir}/vim_plugin_git_repo.txt"
    list_vim_plugins  | sort | tee -a "${workdir}/vim_plugin_git_repo.txt" 
else
    PINFO "no need to update vim plugin list"
fi

PINFO "git commit and push the change ..."
pushd ${workdir} &>/dev/null || exit 1
autocommit
popd &>/dev/null || exit 1
