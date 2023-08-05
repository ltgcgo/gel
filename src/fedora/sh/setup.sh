#!/bin/bash
cd /root/sh/distro
sed -i "s/__FLAVOUR__/Fedora/g" $PREFIX/etc/motd
bash install.sh
dnf clean dbcache
echo "Applying ZSH key fix..."
echo 'bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char' >> $PREFIX/etc/skel/.zshrc
exit
