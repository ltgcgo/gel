#!/bin/bash
cd /root/gel/distro/sh
sed -i "s/__FLAVOUR__/Alpine/g" $PREFIX/etc/motd
bash install.sh
exit