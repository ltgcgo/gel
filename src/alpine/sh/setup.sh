#!/bin/bash
cd /root/sh/distro
sed -i "s/__FLAVOUR__/Alpine/g" $PREFIX/etc/motd
bash install.sh
exit