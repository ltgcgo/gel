#!/bin/bash
echo "Pre-install..."
rm -rf /etc/apt/preferences
rm -rf /etc/apt/sources.list.d
mkdir /etc/apt/sources.list.d
echo "Installation stage 1..."
apt clean
apt update
bash raw.sh apt-transport-https_2.6.1.deb
bash raw.sh openssl_3.0.9.deb
apt -o Dpkg::Options::=--force-confnew install --fix-broken -y
apt -o Dpkg::Options::=--force-confnew install -y ca-certificates apt-transport-https
echo "Installation stage 2..."
apt update
sed -i "s/http/https/g" $PREFIX/etc/apt/sources.list
apt -o Dpkg::Options::=--force-confnew upgrade -y
echo "Installation stage 3..."
apt -o Dpkg::Options::=--force-confnew install -y init doas gnupg gpgv bash zsh ssh \
	unzip zip tar bzip2 lzip lziprecover brotli zopfli pigz lbzip2 plzip xz-utils \
	#webp libjxl-tools vorbis-tools opus-tools \
	dnsutils net-tools traceroute tcptraceroute psmisc nftables \
	nano tree netcat-openbsd socat pv curl git screen htop
echo "Post-install..."
mkdir -p /run/sshd
exit
