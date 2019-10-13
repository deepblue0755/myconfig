#!/bin/bash


if [ "$shell" == "/usr/bin/bash" ];then
    dir=/cygdrive

else
    dir=
fi

echo copy vim _vimrc ...
cp $dir/d/Vim/_vimrc ./_vimrc-$HOSTNAME



echo copy tmux .tmux.conf ...
cp $dir/d/cygwin64/home/$USER/.tmux.conf ./.tmux.conf-$HOSTNAME
