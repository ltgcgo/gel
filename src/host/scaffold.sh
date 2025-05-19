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

# In this file, slim Alpine containers are being created.
if [ ! -f "gel.tlz" ]; then
	curl -Lo "gel.tlz" "https://github.com/ltgcgo/gel/releases/latest/download/slimalp.tlz"
fi
if [ ! -f "gelInst.sh" ]; then
	curl -Lo "gelInst.sh" "https://github.com/ltgcgo/gel/releases/latest/download/install.sh"
fi

# Fetch the LXC container subnet
lxcSubNet="$(ip addr show lxcbr0 | grep "inet " | awk -F ' *|:' '/inet/{print $3}' | cut -d'/' -f1 | cut -d'.' -f1,2,3)"
lxcSubNet=${lxcSubNet:-10.0.3}

# Define names for the containers
names=( "web" "mix" "net" "pod" )
# web: Web servers, static files, etc
# mix: Mixnet access, port forwarders for mixnet exposure, etc
# pod: Actual host for running Docker/Podman containers
startOrder=0
lxcTree="${PREFIX}/var/lib/lxc"

# Create LXC DHCP profile
echo 'LXC_DHCP_CONFILE=/etc/lxc/dhcp.conf' >> "${PREFIX}/etc/default/lxc-net"

# Create the base container to copy from
lxc-create -t download -n alpbase -- --dist alpine --release 3.20 --arch $targetArch
# Copy the setup files of Gel into the containers
mkdir -p "${lxcTree}/alpbase/rootfs/root/gel"
cp -v gel.tlz "${lxcTree}/alpbase/rootfs/root/gel/gel.tlz"
cp -v gelInst.sh "${lxcTree}/alpbase/rootfs/root/gel/install.sh"
# Start the container to begin configuration
lxc-start -n alpbase
echo "Waiting for the container network..."
sleep 4s
lxc-attach -n alpbase -u 0 -g 0 -v "GEL_SLIM=1" -- sh "/root/gel/install.sh"
lxc-stop -n alpbase
chmod 755 "${lxcTree}"

# Create subsequent containers
for name in ${names[@]}; do
	printf "Configuring container: \"${name}\"..."
	# Paths of the container
	lxcPath="${lxcTree}/${name}"
	lxcConf="${lxcPath}/config"
	lxcRoot="${lxcPath}/rootfs"
	# Create from base
	lxc-copy -n alpbase -N "${name}"
	# Configure autostart
	echo -e "\nlxc.start.order = $(($startOrder+1))\nlxc.start.auto = 1\nlxc.start.delay = 4" >> "${lxcConf}"
	# Enable FUSE
	echo -e "lxc.mount.entry = /dev/fuse dev/fuse none bind,create=file,rw 0 0" >> "${lxcConf}"
	# Enable TUN
	echo -e "lxc.mount.entry = /dev/net dev/net none bind,create=dir\nlxc.cgroup2.devices.allow = c 10:200 rwm" >> "${lxcConf}"
	# Assign static IPv4 addresses
	echo -e "dhcp-host=${name},10.0.3.$(($startOrder+3))" >> "${PREFIX}/etc/lxc/dhcp.conf"
	# Assign static MAC addresses for static IPv6 addresses
	echo -e "lxc.net.0.hwaddr = DE:ED:0E:A0:38:0${startOrder}" >> "${lxcConf}"
	# Show the container name
	echo "${name}" > "${lxcRoot}/etc/zsh/.customShellName"
	# Configure subordinate IDs for unprivileged slices
	subidConf="$((1048576+1048576*$startOrder))"
	echo "root:${subidConf}:1048576" >> /etc/subuid
	echo "root:${subidConf}:1048576" >> /etc/subgid
	echo -e "lxc.include = /usr/share/lxc/config/userns.conf\nlxc.idmap = u 0 ${subidConf} 1048576\nlxc.idmap = g 0 ${subidConf} 1048576" >> "${lxcConf}"
	chmod 755 "${lxcPath}"
	chmod 755 "${lxcRoot}"
	chmod 640 "${lxcConf}"
	chown -R "${subidConf}:${subidConf}" "${lxcRoot}"
	# Increase the start order
	startOrder=$(($startOrder+1))
	echo " done."
done

# Configuring "web"
echo -e "lxc.cgroup2.memory.max = 384M" >> "${lxcTree}/web/config"
lxc-start -n "web"
lxc-attach -n "web" -u 0 -- apk add caddy coredns haproxy
lxc-attach -n "web" -u 0 -- systemctl enable caddy
lxc-attach -n "web" -u 0 -- systemctl enable coredns
lxc-attach -n "web" -u 0 -- systemctl enable haproxy
lxc-stop -n "web"

# Configuring "mix"
echo -e "lxc.cgroup2.memory.max = 256M" >> "${lxcTree}/mix/config"
echo -e "lxc.cgroup2.cpu.max = 200000 1000000" >> "${lxcTree}/mix/config"
lxc-start -n "mix"
lxc-attach -n "mix" -u 0 -- apk add tor nyx i2pd yggdrasil
lxc-attach -n "mix" -u 0 -- systemctl enable tor
lxc-attach -n "mix" -u 0 -- systemctl enable i2pd
lxc-attach -n "mix" -u 0 -- systemctl enable yggdrasil
lxc-attach -n "mix" -u 0 -- bash -c 'yggdrasil -genconf > /etc/yggdrasil/yggdrasil.conf'
lxc-stop -n "mix"
sed -i "s/ipv6 = false/ipv6 = true/g" "${lxcTree}/mix/rootfs/etc/i2pd/i2pd.conf"
sed -i 's/# bandwidth = L/bandwidth = 5120/g' "${lxcTree}/mix/rootfs/etc/i2pd/i2pd.conf"
sed -i 's/# notransit = true/notransit = true/g' "${lxcTree}/mix/rootfs/etc/i2pd/i2pd.conf"
sed -i "s/# address = 127.0.0.1/address = 10.0.3.5/g" "${lxcTree}/mix/rootfs/etc/i2pd/i2pd.conf"
sed -i "s/# outproxy = http:\/\/false.i2p/outproxy = http:\/\/exit.stormycloud.i2p/g" "${lxcTree}/mix/rootfs/etc/i2pd/i2pd.conf"
echo "ExcludeNodes {kp},{ir},{cu},{cn},{hk},{mo},{ru},{sy},{pk}" > "${lxcTree}/mix/rootfs/etc/tor/torrc"
echo "StrictNodes 1" >> "${lxcTree}/mix/rootfs/etc/tor/torrc"
echo "ClientUseIPv6 1" >> "${lxcTree}/mix/rootfs/etc/tor/torrc"
echo "IPv6Exit 1" >> "${lxcTree}/mix/rootfs/etc/tor/torrc"
echo "SocksPort 10.0.3.5:9050" >> "${lxcTree}/mix/rootfs/etc/tor/torrc"
echo "ControlPort 9051" >> "${lxcTree}/mix/rootfs/etc/tor/torrc"

# Configuring "pod"
echo -e "lxc.include = /usr/share/lxc/config/nesting.conf" >> "${lxcTree}/pod/config"
echo -e "lxc.cgroup2.cpu.max = 400000 1000000" >> "${lxcTree}/pod/config"
echo -e "lxc.prlimit.nofile = 1048576" >> "${lxcTree}/pod/config"
echo -e "user:131074:524288" >> "${lxcTree}/pod/rootfs/etc/subuid"
echo -e "user:131074:524288" >> "${lxcTree}/pod/rootfs/etc/subgid"
lxc-start -n "pod"
lxc-attach -n "pod" -u 0 -- apk add podman podman-compose
#lxc-attach -n "pod" -u 1000 -- podman system migrate
lxc-stop -n "pod"

# Configuring "net"
lxc-start -n "net"
lxc-attach -n "net" -u 0 -- apk add wireguard-tools deno
echo -e '#!/sbin/openrc-run\n\ndescription="WireGuard auto-start helper"\n\ndepend() {\n\tneed localmount\n\tneed net\n}\n\nstart() {\n}\n\nstop() {\n}' > "${lxcTree}/pod/rootfs/etc/init.d/wgstarter"
lxc-attach -n "net" -u 0 -- bash -c 'chmod +x /etc/init.d/wgstarter'
lxc-attach -n "net" -u 0 -- systemctl enable wgstarter
lxc-stop -n "net"

# Finishing touches
startOrder=0
for name in ${names[@]}; do
	echo "Finalizing \"${name}\"..."
	subidConf="$((1048576+1048576*$startOrder))"
	chown -R "${subidConf}:${subidConf}" "${lxcTree}/${name}/rootfs"
	echo "Starting \"${name}\"..."
	lxc-start -n "${name}"
	startOrder=$(($startOrder+1))
done

# Why?
lxc-attach -n "pod" -u 0 -- useradd -u 1000 -d /home/user -k /etc/skel -m -s "/bin/zsh" user

# All done!
exit