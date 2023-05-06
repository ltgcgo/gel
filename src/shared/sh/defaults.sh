#!/bin/bash
# Configure default root password
echo "root:root" | chpasswd
# Point iptables to nftables
ln -s /sbin/iptables-nft /sbin/iptables
exit