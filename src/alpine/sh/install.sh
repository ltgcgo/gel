#!/bin/bash
echo "Pre-install..."
apk upgrade
echo "Installation stage 1..."
apk add ca-certificates
echo "Installation stage 2..."
apk add openrc doas gpg gpgv bash zsh zsh-vcs openssh-server \
	unzip zip tar bzip2 lzip brotli zopfli pigz \
	libwebp libjxl-tools vorbis-tools opus-tools \
	bind-tools net-tools iputils traceroute tcptraceroute psmisc nftables coreutils \
	nano tree netcat-openbsd socat pv curl git screen htop neofetch
echo "Post-install..."
mkdir -p /run/sshd
rc-update add sshd default
cp ./systemctl /bin
exit