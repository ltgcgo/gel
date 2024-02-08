#!/bin/bash
cd ~root/gel/distro/sh
sed -i "s/__FLAVOUR__/Debian/g" $PREFIX/etc/motd
bash install.sh
apt clean
exit