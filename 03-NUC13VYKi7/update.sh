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


workdir="/home/$(id -nu 1000)/documents/11-configs-from-github/03-NUC13VYKi7/"

if [[ ! -d "${workdir}" ]];then
    PERROR "can not find work directory ${workdir}"
    exit 1
fi

PINFO "dpkg -l > ${workdir}/dpkg-lists.txt"
dpkg -l > "${workdir}/dpkg-lists.txt"

PINFO "apt list --installed > ${workdir}/deb-packages-list.txt ..."
apt list --installed > "${workdir}/deb-packages-list.txt"


PINFO "update vim plugin list ..."
truncate -s 0 "${workdir}/vim_plugin_git_repo.txt"
pushd ~/.vim/bundle/ &>/dev/null || exit 1
for folder in  $(find ./ -maxdepth 1 -type d | grep -v "\./$")
do
    pushd $folder &>/dev/null || exit 1
        git remote -v | grep origin | sed -n 1p | awk '{ print $2 }' | tee -a ${workdir}/vim_plugin_git_repo.txt
    popd &>/dev/null || exit 1
done
popd &>/dev/null || exit 1
