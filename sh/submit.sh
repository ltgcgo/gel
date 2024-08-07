#!/bin/bash
if [ -d "./dist/${1}/" ] ; then
	cd ./dist/${1}
	podman build -t gel_${1}_latest .
	podman push gel_${1}_latest docker://docker.io/${DH_USER:-ltgc}/gel:${1}
	podman rmi gel_${1}_latest
	if [ "$?" != "0" ]; then
		echo "Image build failed. Attempting to skip the step..."
	fi
else
	echo "Image \"${1}\" not found."
fi
exit