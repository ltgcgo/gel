#!/bin/sh
rawArch=$(uname -m)
transArchDeb=$rawArch
transArchDnf=$rawArch
case $rawArch in
	"x86_64" | "amd64")
		transArchDeb="amd64"
		transArchDnf="x86_64"
		;;
	"arm64" | "armv8l" | "aarch64")
		transArchDeb="arm64"
		transArchDnf="aarch64"
		;;
esac
# Read the distro name
rawId=$(cat $PREFIX/etc/os-release | grep -E "^ID=" | cut -d'=' -f2)
distroId="$(echo $rawId | sed -e "s/\"//g")"
if [ -z "$distroId" -a "$distroId" != " " ]; then
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
if [ -z "$DRY_RUN" -a "$DRY_RUN" != " " ]; then
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
		if [ "$?" != "0" ]; then
			curl -Lso "lzip.rpm" "https://dl.fedoraproject.org/pub/epel/9/Everything/x86_64/Packages/l/lzip-1.22-3.el9.${transArchDnf}.rpm"
			$installCmd --nogpgcheck "lzip.rpm"
		fi
	fi
	cd "$PREFIX/root/"
	mkdir -p gel
	cd gel
fi
if [ ! -f "./gel.tlz" ]; then
	getPrefix="https://github.com/ltgcgo/gel/releases/latest/download"
	echo "Testing connectivity to GitHub..."
	curl -ILs -m 8 "https://raw.githubusercontent.com/" > /dev/null
	if [ "$?" = "0" ]; then
		echo "Downloading configuration data from GitHub."
	else
		echo "Downloading configuration data from Codeberg."
		getPrefix="https://codeberg.org/ltgc/gel/releases/download/latest"
	fi
	if [ -z "$DRY_RUN" -a "$DRY_RUN" != " " ]; then
		curl -Lo gel.tlz "${getPrefix}/${distroId}.tlz"
	else
		echo "Skipping download due to dry run."
	fi
else
	echo "Using the local install package."
fi
if [ -z "$DRY_RUN" -a "$DRY_RUN" != " " ]; then
	echo "Decompressing files..."
	lzip -d -c gel.tlz | tar -xf -
	bash shared/sh/native.sh
else
	echo "Skipping installation due to dry run."
fi
exit
