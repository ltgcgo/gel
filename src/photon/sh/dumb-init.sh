#!/bin/bash
rawArch=$(uname -m)
transArch=$rawArch
case $rawArch in
	"x86_64" | "amd64")
		transArch="amd64"
		;;
	"arm64" | "armv8l" | "aarch64")
		transArch="arm64"
		;;
esac
lzip -k -d -c "${transArch}/dumb-init_1.2.5.lz" > "/sbin/dumb-init"
ln -s ./dumb-init /sbin/init
chmod +x /sbin/dumb-init
exit
