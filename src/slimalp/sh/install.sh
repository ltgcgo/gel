#!/bin/bash
echo "Pre-install..."
apk upgrade
echo "Installation stage 1..."
apk add ca-certificates
echo "Installation stage 2..."
apk add openrc doas bash zsh zsh-vcs openssh-server \
	unzip tar brotli \
	bind-tools net-tools iputils psmisc nftables coreutils \
	nano tree netcat-openbsd pv curl
echo "Post-install..."
mkdir -p /run/sshd
rc-update add sshd default
mv ./systemctl /bin
mv ./shutdown /sbin
mv ./sgerrand.rsa.pub /etc/apk/keys/
exit
