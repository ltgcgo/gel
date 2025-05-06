#!/bin/bash
# Root-owned unprivileged containers baby!

# Global variables
REQUIRES_APPARMOR=1
ERRORED_EXIT=0
if [ -f "/etc/redhat-release" ] ; then
	# Fallback for RHEL
	REQUIRES_APPARMOR=0
fi
if [ -f "/usr/share/lxc/templates/lxc-download" ] ; then
	echo "LXC template downloader check passed."
else
	echo "LXC template downloader not available."
	ERRORED_EXIT=$(($ERRORED_EXIT+1))
fi

# Detect if apparmor exists
if [ "$REQUIRES_APPARMOR" == "1" ] ; then
	# AppArmor needed
	if [ -f "/usr/local/sbin/apparmor_parser" ] ; then
		echo "AppArmor integrity check passed."
	elif [ -f "/usr/sbin/apparmor_parser" ] ; then
		echo "AppArmor integrity check passed."
	elif [ -f "/sbin/apparmor_parser" ] ; then
		echo "AppArmor integrity check passed."
	else
		echo "AppArmor is not installed on this system. Install the \"apparmor\" (apparmor_parser) package first."
		ERRORED_EXIT=$(($ERRORED_EXIT+1))
	fi
else
	echo "AppArmor integrity check skipped. This system does not use AppArmor."
fi

# Detect if root access is available
if [ "$(whoami)" != "root" ] ; then
	echo "This script requires root permissions."
	ERRORED_EXIT=$(($ERRORED_EXIT+1))
fi

# Total error counts
if [ "$ERRORED_EXIT" != "0" ] ; then
	echo "Encountered ${ERRORED_EXIT} error(s). The script can no longer run."
	exit 1
fi

cd ~root
# Automatically adapt to host architecture
hostArch=$(uname -m)
targetArch="unsupported"
case $hostArch in
	"x86_64" | "amd64")
		targetArch="amd64"
		;;
	"arm64" | "armv8l" | "aarch64")
		targetArch="arm64"
		;;
esac

# Fetch the LXC container subnet
lxcSubNet="$(ip addr show lxcbr0 | grep "inet " | awk -F ' *|:' '/inet/{print $3}' | cut -d'/' -f1 | cut -d'.' -f1,2,3)"
lxcSubNet=${lxcSubNet:-10.0.3}

# Define names for the containers
names=( "web" "mix" "pod" "net" )
# web: Web servers, static files, etc
# mix: Mixnet access, port forwarders for mixnet exposure, etc
# pod: Actual host for running Docker/Podman containers
startOrder=1
lxcTree="${PREFIX}/var/lib/lxc"
mkdir -p gel
cd gel

# In this file, slim Alpine containers are being created.
if [ ! -f "gel.zip" ]; then
	curl -Lo "gel.zip" "https://github.com/ltgcgo/gel/releases/latest/download/slimalp.zip"
fi
if [ ! -f "gelInst.sh" ]; then
	curl -Lo "gelInst.sh" "https://github.com/ltgcgo/gel/releases/latest/download/install.sh"
fi

# Create the base container to copy from
lxc-create -t download -n base -- --dist alpine --release 3.21 --arch $targetArch
# Copy the setup files of Gel into the containers
mkdir -p "${lxcTree}/base/rootfs/root/gel"
cp -v gel.zip "${lxcTree}/base/rootfs/root/gel/gel.zip"
cp -v gelInst.sh "${lxcTree}/base/rootfs/root/install.sh"
# Start the container to begin configuration
lxc-start -n base
sleep 5s
lxc-attach --clear-env -n base -u 0 -g 0 -v "GEL_SLIM=1" -- sh "/root/install.sh"
lxc-stop -n base

# Create subsequent containers

# All done!
exit