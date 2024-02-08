#!/bin/bash
echo "Pre-install..."
rm -rf /etc/apt/preferences
rm -rf /etc/apt/sources.list.d
mkdir /etc/apt/sources.list.d
echo "Installation stage 1..."
apt clean
apt update
bash raw.sh apt-transport-https_2.6.1.deb
if [ "$MODE_NATIVE" != "1" ]; then
	bash raw.sh openssl_3.0.9.deb
fi
apt -o Dpkg::Options::=--force-confnew install --fix-broken -y
apt -o Dpkg::Options::=--force-confnew install -y ca-certificates apt-transport-https
echo "Installation stage 2..."
apt update
sed -i "s/http/https/g" $PREFIX/etc/apt/sources.list
apt -o Dpkg::Options::=--force-confnew upgrade -y
echo "Installation stage 3..."
apt -o Dpkg::Options::=--force-confnew install -y init doas bash zsh ssh \
	unzip tar bzip2 brotli xz-utils \
	dnsutils net-tools psmisc nftables \
	nano tree netcat-openbsd pv curl
echo "Post-install..."
apt clean
mkdir -p /run/sshd
exit