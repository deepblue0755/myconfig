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
