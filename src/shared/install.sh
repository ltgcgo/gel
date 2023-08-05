#!/bin/sh
# Read the distro name
rawId=$(cat $PREFIX/etc/os-release | grep -E "^ID=" | cut -d'=' -f2)
distroId="$(echo $rawId | sed -e "s/\"//g")"
if [ "$distroId" == "" ]; then
	if [ "$TERMUX_VERSION" != "" ]; then
		distroId="termux"
	else
		echo "Failed to read distro name."
		exit 1
	fi
fi
case "$distroId" in
	"alpine" | "debian" | "opensuse" | "rocky" | "fedora")
		echo "Supported distro detected: ${distroId}"
		;;
	*)
		echo "Unknown distro: ${distroId}"
		;;
esac
# Select the correct package manager
preInstCmd=
installCmd=
if [ -e "$(which dpkg 2>/dev/null)" ]; then
	preInstCmd="apt update -y"
	installCmd="apt install -y"
elif [ -e "$(which rpm 2>/dev/null)" ]; then
	installCmd="dnf install -y"
elif [ -e "$(which apk 2>/dev/null)" ]; then
	installCmd="apk add"
else
	echo "not found."
	exit 1
fi
if [ "$preInstCmd" != "" ]; then
	$preInstCmd
fi
if [ ! -f "$(which curl)" ]; then
	$installCmd curl
fi
if [ ! -f "$(which bash)" ]; then
	$installCmd bash
fi
if [ ! -f "$(which unzip)" ]; then
	$installCmd unzip
fi
cd ~
mkdir -p gel
cd gel
if [ ! -f "./gel.zip" ]; then
	curl -Lo gel.zip "https://github.com/ltgcgo/gel/releases/latest/download/${distroId}.zip"
fi
unzip gel.zip
bash shared/sh/native.sh
exit