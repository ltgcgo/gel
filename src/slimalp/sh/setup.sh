#!/bin/bash
cd /root/gel/distro/sh
sed -i "s/__FLAVOUR__/Alpine Slim/g" $PREFIX/etc/motd
bash install.sh
bash cleanup.sh
echo "Applying ZSH key fix..."
echo 'bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char' >> $PREFIX/etc/skel/.zshrc
exit