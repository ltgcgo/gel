#!/bin/bash
# Configure default root password
groupadd -f sshuser
if [ "$MODE_NATIVE" != "1" ]; then
	echo "root:root" | chpasswd
fi
# Point iptables to nftables
ln -s /sbin/iptables-nft /sbin/iptables
exit