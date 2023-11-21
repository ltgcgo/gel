#!/bin/bash
# Configure default root password
if [ "$MODE_NATIVE" != "1" ]; then
	echo "root:root" | chpasswd
fi
# Point iptables to nftables
ln -s /sbin/iptables-nft /sbin/iptables
exit