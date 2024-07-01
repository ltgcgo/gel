#!/bin/bash
cd ~root/gel/distro/sh
sed -i "s/__FLAVOUR__/AlmaLinux/g" $PREFIX/etc/motd
#bash init.sh
bash install.sh
#dnf clean dbcache
dnf clean all
echo "Applying ZSH key fix..."
echo 'bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char' >> $PREFIX/etc/skel/.zshrc
exit
