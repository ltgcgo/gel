#!/bin/sh
# Read the distro name
rawId=$(cat $PREFIX/etc/os-release | grep -E "^ID=" | cut -d'=' -f2)
distroId="$(echo $rawId | sed -e "s/\"//g")"
if [[ "$distroId" == "" ]]; then
	if [[ "$TERMUX_VERSION" != "" ]]; then
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
elif [ -e "$(which dnf 2>/dev/null)" ]; then
	installCmd="dnf install -y"
elif [ -e "$(which zypper 2>/dev/null)" ]; then
	installCmd="zypper in -y"
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
if [ ! -f "$(which tar)" ]; then
	$installCmd tar
fi
if [ ! -f "$(which lzip)" ]; then
	$installCmd lzip
fi
cd ~
mkdir -p gel
cd gel
if [ ! -f "./gel.tlz" ]; then
	curl -Lo gel.tlz "https://github.com/ltgcgo/gel/releases/latest/download/${distroId}.tlz"
fi
tar xf --lzip gel.tlz
bash shared/sh/native.sh
exit
