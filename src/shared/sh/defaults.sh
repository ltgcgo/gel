#!/bin/bash
# Configure default root password
echo "root:root" | chpasswd
# Point iptables to nftables
update-alternatives --set iptables /usr/sbin/iptables-nft
exit