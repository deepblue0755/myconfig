20240507:
    1. comment the line in /etc/sudoers: 
        ```
            # Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
        ```
    so that sudo vim can use the /usr/local/vim/9.1.0366/bin/vim instead of the
    /usr/bin/vim in the secure path
    2. create a softlink in /root by ln -s /home/huangmianbo/.vimrc /root
    3. create a softlink in /root by ln -s /home/huangmianbo/.vim /root


