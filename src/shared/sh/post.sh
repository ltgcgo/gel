#!/bin/bash
cd $PREFIX/root/gel/shared/sh
bash syncSkel.sh
rm -rf $PREFIX/var/log
mkdir -p $PREFIX/var/log
#rm -rf $PREFIX/root/sh
sysctl -w net.core.default_qdisc=fq
sysctl -w net.ipv4.tcp_congestion_control=bbr
exit
