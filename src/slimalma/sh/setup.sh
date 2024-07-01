#!/bin/bash
cd ~root/gel/distro/sh
sed -i "s/__FLAVOUR__/AlmaLinux Slim/g" $PREFIX/etc/motd
#bash init.sh
bash install.sh
#dnf clean dbcache
dnf clean all
bash cleanup.sh
echo "Applying ZSH key fix..."
echo 'bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char' >> $PREFIX/etc/skel/.zshrc
exit
