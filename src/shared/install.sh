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
case "$GEL_SLIM" in
	"1")
		# Slim
		case "$distroId" in
			"alpine")
				echo "Supported distro detected: ${distroId}"
				distroId=slimalp
				;;
			"debian")
				echo "Supported distro detected: ${distroId}"
				distroId=slimdeb
				;;
			"opensuse")
				echo "Supported distro detected: ${distroId}"
				distroId=slimsuse
				;;
			"rocky")
				echo "Supported distro detected: ${distroId}"
				distroId=slimrock
				;;
			"almalinux")
				echo "Supported distro detected: ${distroId}"
				distroId=slimalma
				;;
			"photon")
				echo "Supported distro detected: ${distroId}"
				;;
			*)
				echo "Unknown distro: ${distroId}"
				exit 1
				;;
		esac
		;;
	*)
		# Regular
		case "$distroId" in
			"alpine" | "debian" | "opensuse" | "rocky" | "almalinux")
				echo "Supported distro detected: ${distroId}"
				;;
			*)
				echo "Unknown distro: ${distroId}"
				exit 1
				;;
		esac
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
elif [ -e "$(which tdnf 2>/dev/null)" ]; then
	installCmd="tdnf install -y"
elif [ -e "$(which zypper 2>/dev/null)" ]; then
	installCmd="zypper in -y"
elif [ -e "$(which apk 2>/dev/null)" ]; then
	installCmd="apk add"
else
	echo "Supported package manager not found."
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
	curl -Is https://raw.githubusercontent.com/ > /dev/null
	curl -Lo gel.tlz "https://github.com/ltgcgo/gel/releases/latest/download/${distroId}.tlz"
else
	echo "Using the local install package."
fi
lzip -d -c gel.tlz | tar -xf -
bash shared/sh/native.sh
exit
