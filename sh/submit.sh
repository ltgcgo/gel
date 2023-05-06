#!/bin/bash
if [ -d "./dist/${1}/" ] ; then
	cd ./dist/${1}
	podman rmi gel_${1}_latest
	podman build gel_${1}_latest
	podman push gel_${1}_latest docker://docker.io/${USERNAME:-ltgcgo}/gel:debian
else
	echo "Image \"${1}\" not found."
fi
exit