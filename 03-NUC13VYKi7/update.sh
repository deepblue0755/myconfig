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
    echo  -e "${GREEN}INFO ($BASH_LINENO): $* ${NORMAL}"
    return 0
}

function PERROR() {
    echo  -e "${RED}ERROR ($BASH_LINENO): $* ${NORMAL}"
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


workdir="/home/$(id -nu 1000)/documents/11-configs-from-github/03-NUC13VYKi7/"

if [[ ! -d "${workdir}" ]];then
    PERROR "can not find work directory ${workdir}"
    exit 1
fi

PINFO "git pull ..."
if ! git pull &>/dev/null;then
    PERROR "git pull failed"
else
    PINFO "successfully git pull"
fi


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
