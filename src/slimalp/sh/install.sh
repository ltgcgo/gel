#!/bin/bash
echo "Pre-install..."
apk upgrade
echo "Installation stage 1..."
apk add ca-certificates
echo "Installation stage 2..."
apk add openrc doas bash zsh zsh-vcs openssh-server \
	unzip tar bzip2 brotli xz \
	bind-tools net-tools iputils psmisc nftables coreutils \
	nano tree netcat-openbsd pv
echo "Post-install..."
mkdir -p /run/sshd
rc-update add sshd default
cp ./systemctl /bin
exit