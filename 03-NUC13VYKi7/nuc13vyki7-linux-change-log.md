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


