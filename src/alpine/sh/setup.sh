#!/bin/bash
cd /root/gel/distro/sh
sed -i "s/__FLAVOUR__/Alpine/g" $PREFIX/etc/motd
bash install.sh
if [ "$MODE_NATIVE" != "" ]; then
	apk add libcap-utils
fi
echo "Removing glibc specific files..."
rm $PREFIX/etc/gai.conf
echo "Applying ZSH key fix..."
echo 'bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char' >> $PREFIX/etc/skel/.zshrc
exit