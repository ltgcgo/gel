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
printf "Detecting package manager backend... "
installCmd=
if [ -e "$(which dpkg 2>/dev/null)" ]; then
	echo "using dpkg."
	installCmd="dpkg -i"
elif [ -e "$(which rpm 2>/dev/null)" ]; then
	echo "using rpm."
	installCmd="rpm -ivh"
elif [ -e "$(which apk 2>/dev/null)" ]; then
	echo "using apk."
	installCmd="apk add"
else
	echo "not found."
	exit 1
fi
printf "Finding file for $1... "
packagePath=
if [ -e "./${transArch}/$1" ]; then
	echo "for ${transArch}."
	packagePath="./${transArch}/$1"
elif [ -e "./all/$1" ]; then
	echo "for noarch."
	packagePath="./all/$1"
else
	echo "file not found."
	exit 1
fi
echo "Installing $1..."
$installCmd $packagePath
exit
