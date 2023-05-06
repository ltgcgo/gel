#!/bin/bash
echo "Pre-install..."
apk upgrade
echo "Installation stage 1..."
apk add ca-certificates
echo "Installation stage 2..."
apk add openrc doas gpg gpgv bash zsh zsh-vcs openssh-server \
	unzip zip bzip2 lzip brotli \
	bind-tools net-tools iputils traceroute tcptraceroute psmisc coreutils \
	nano tree netcat-openbsd pv git screen htop neofetch
echo "Post-install..."
mkdir -p /run/sshd
rc-update add sshd default
exit