#!/bin/bash
cd $PREFIX/root/gel/shared/sh
bash syncSkel.sh
rm -rf $PREFIX/var/log
mkdir -p $PREFIX/var/log
#rm -rf $PREFIX/root/sh
if [ "$MODE_NATIVE" != "" ]; then
	echo "Customizing for native systems..."
	sysctl -w net.core.default_qdisc=fq
	sysctl -w net.ipv4.tcp_congestion_control=bbr
	echo "Done."
else
	echo "Customizing for container systems..."
	rm $PREFIX/etc/sysctl.d/netNative.conf
	echo "Done."
fi
exit
