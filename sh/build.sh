#!/bin/bash
EXT_NAME="tlz"
if [ "${1}" == "" ] ; then
	echo "Image name not defined."
elif [ -d "./src/${1}/" ] ; then
	echo "Installer bundle for target \"${1}\" started."
	rm -r "./build/${1}" 2> /dev/null
	rm "./build/${1}.${EXT_NAME}" 2> /dev/null
	mkdir -p "./build/${1}"
	cd "./build/${1}"
	echo "Copying required files..."
	mkdir -p "shared"
	cp -Lr "../../src/shared/etc" "./shared"
	cp -Lr "../../src/shared/sh" "./shared"
	mkdir -p "distro"
	cp -Lr "../../src/${1}/etc" "./distro"
	cp -Lr "../../src/${1}/sh" "./distro"
	echo "Filling for values..."
	sed -i "s/__VERSION__/$(cat ../../build_version)/g" "./shared/etc/motd"
	echo "Bundling..."
	tar cf "../${1}.tar" *
	lzip -k9 -c "../${1}.tar" > "../${1}.${EXT_NAME}"
	rm "../${1}.tar"
	echo "Installer bundle emit finished."
	cd ../..
	rm -r "./build/${1}" 2> /dev/null
else
	echo "Image \"${1}\" not found."
fi
exit
