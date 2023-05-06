#!/bin/bash
shx build
if [ -d "./dist/${1}/" ] ; then
	cd ./dist/${1}
	podman container rm debian_gel_1
	podman rmi debian_gel
	podman-compose up -d
else
	echo "Image \"${1}\" not found."
fi
exit