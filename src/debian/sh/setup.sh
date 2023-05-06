#!/bin/bash
cd /root/sh/distro
sed -i "s/__FLAVOUR__/Debian/g" $PREFIX/etc/motd
bash install.sh
apt clean
exit