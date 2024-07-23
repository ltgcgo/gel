#!/bin/bash
cd ~root/gel/distro/sh
sed -i "s/__FLAVOUR__/Photon/g" $PREFIX/etc/motd
bash install.sh
tdnf clean all
exit
