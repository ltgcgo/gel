#!/bin/bash
apt update
apt -o Dpkg::Options::=--force-confnew upgrade -y
apt install -y apt-transport-https \
	doas sudo- gnupg gpgv bash zsh \
	unzip zip bzip2 lzip lziprecover brotli \
	dnsutils net-tools traceroute tcptraceroute psmisc \
	tree netcat-openbsd pv curl git screen htop neofetch
exit