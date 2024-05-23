20240507:
    1. comment the line in /etc/sudoers: 
        ```
            # Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
        ```
    so that sudo vim can use the /usr/local/vim/9.1.0366/bin/vim instead of the
    /usr/bin/vim in the secure path
    2. create a softlink in /root by ln -s /home/huangmianbo/.vimrc /root
    3. create a softlink in /root by ln -s /home/huangmianbo/.vim /root
    4. add two service set-static-ip-192_168_0@.service set-static-ip-192_168_1@.service for set the 192.168.0.0/24 and 192.168.1.0/24 static ip to the NIC


20240509:
    1. upgrade libc6 less libglib2.0-0 libglib2.0-bin libglib2.0-data libglib2.0-dev libglib2.0-dev-bin linux-image-amd64 linux-libc-dev by
    apt upgrade
    
20240517:
    1. install i386 libs for running codesys runtime by:
    sudo apt install libc6:i386 libc6:i386 libstdc++6:i386 zlib1g:i386 \
    libglib2.0-0:i386 libfontconfig1:i386 libaudio2:i386 libxrender1:i386 \
    libxext6:i386 libjpeg62-turbo:i386 libgstreamer1.0-0:i386 \
    gstreamer1.0-plugins-base:i386 libsqlite3-0:i386 libgl1:i386 libgl1:i386

