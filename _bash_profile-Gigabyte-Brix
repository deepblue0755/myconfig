# To the extent possible under law, the author(s) have dedicated all 
# copyright and related and neighboring rights to this software to the 
# public domain worldwide. This software is distributed without any warranty. 
# You should have received a copy of the CC0 Public Domain Dedication along 
# with this software. 
# If not, see <http://creativecommons.org/publicdomain/zero/1.0/>. 

# base-files version 4.2-4

# ~/.bash_profile: executed by bash(1) for login shells.

# The latest version as installed by the Cygwin Setup program can
# always be found at /etc/defaults/etc/skel/.bash_profile

# Modifying /etc/skel/.bash_profile directly will prevent
# setup from updating it.

# The copy in your home directory (~/.bash_profile) is yours, please
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benifitial to all, please feel free to send
# a patch to the cygwin mailing list.

# User dependent .bash_profile file

if [ -e $USER ];then
    export USER=mianb
fi

if [ "$SHELL" == "/usr/bin/bash" ];then
    dir=
fi

if [ "$SHELL" == "/bin/bash" ];then
    dir=/cygdrive
fi

EDITOR=$dir/d/Vim/vim81/gvim;export EDITOR


function _update_task()
{
    cd $HOME &&  \
    git add .task && \
    git commit -m "update task from $HOSTNAME : $1" && \
    git push -u local master
}

function _gvim()
{
    $dir/d/Vim/vim81/gvim $* &
}

function _md2pdf()
{
    file=$1
    pdffile=${file/.md/.pdf/}
    if [ ! -f "$file" ];then
        echo "error:there's no such file $file"
        return -1
    fi
    pandoc --pdf-engine=pdflatex $file -o $pdffile 
}

function _SumatraPDF()
{
    SumatraPDF $* &> /dev/null &
}

function set_path()
{

    PATH=$dir/d/emacs-26.2-x86_64/bin:$PATH
    PATH=$dir/c/Windows/System32:$PATH
    PATH=$dir/d/7-Zip-18.05-x64:$PATH
    PATH=$dir/d/Beyond\ Compare\ 3/:$PATH
    PATH=$dir/d/ES-1.1.0.10:$PATH
    PATH=$dir/d/Python27-64:$PATH
    PATH=$dir/d/Python37-64:$PATH
    PATH=$dir/d/VLC-3.0.6:$PATH
    PATH=$dir/d/Wireshark-3.0.1:$PATH
    PATH=$dir/d/ffmpeg-4.1.1/bin:$PATH
    PATH=$dir/d/gnuplot-5.2.6/bin:$PATH
    PATH=$dir/d/texlive/2018/bin/win32:$PATH
    PATH=$dir/d/vim/vim81/:$PATH
    PATH=$dir/d/SumatraPDF/:$PATH
    PATH=$dir/d/Git/bin:$PATH
    PATH=$dir/d/Git:$PATH

    # do not add cygwin/bin to $PATH
    if [ "$SHELL" == "/bin/bash" ];then
        PATH=$dir/d/cygwin64/bin/:$PATH
    fi

    export PATH

}

function set_alias()
{
    alias vim='_gvim'
    alias vi='vim'
    alias grep='grep --color=auto'
    alias xgrep='grep -nHR'
    alias gbash='git-bash'
    alias mac='ssh huangmianbo@Huangs-MBP'
    alias ls='ls --color=auto'
    alias rasp3='ssh huangmianbo@raspberry3'
    alias rasp4='ssh huangmianbo@raspberrypi4'
    alias pi3='ssh huangmianbo@raspberry3'
    alias pi4='ssh pi@raspberrypi4'
    alias rm='rm -iv -d'
    alias mv='mv -iv'
    alias aspell-tex='aspell --mode=tex --list'
    alias pdf='_SumatraPDF'
    alias es='es -highlight'
    alias reload='source $HOME/.bash_profile' 
    alias config='vim D:\\cygwin64\\home\\mianb\\.bash_profile' 
    alias tc='task cale'
    alias tl='task list'
    alias syncbash='cp -iv $HOME/.bash_profile /cygdrive/f/05-To-From-Gigabyte-MiniComputer/'
    alias synctask='pushd . && cd $HOME && git pull origin master && popd'
    alias uptask='_update_task'
    alias find='/d/cygwin64/bin/find'
    alias md2pdf='_md2pdf'
    alias doc='cd ~/documents'
    alias videos='cd ~/videos'
    alias ..='cd ..'
    alias ...='cd ../../'
    alias ....='cd ../../../'
    alias ~='cd ~'
    alias mdkir='mkdir'
}


set_path
set_alias
task list

set -o vi
