#!/bin/bash
cd ~root/gel/distro/sh
sed -i "s/__FLAVOUR__/openSUSE Slim/g" $PREFIX/etc/motd
bash install.sh
bash cleanup.sh
zypper clean -a
exit