#!/bin/bash
cd /root/sh/distro
sed -i "s/__FLAVOUR__/openSUSE/g" $PREFIX/etc/motd
bash install.sh
exit