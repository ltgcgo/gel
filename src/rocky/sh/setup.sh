#!/bin/bash
cd /root/sh/distro
sed -i "s/__FLAVOUR__/Rocky Linux/g" $PREFIX/etc/motd
bash install.sh
dnf clean dbcache
exit
