#!/bin/bash
cd /root/sh/distro
sed -i "s/__FLAVOUR__/Fedora/g" $PREFIX/etc/motd
bash install.sh
dnf clean packages
exit