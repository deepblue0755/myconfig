#!/bin/bash


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
