#!/bin/bash
shx build
if [ -d "./dist/${1}/" ] ; then
	cd ./dist/${1}
	podman stop ${1}_gel_1
	podman container rm ${1}_gel_1
	podman rmi ${1}_gel
	all_proxy= HTTPS_PROXY= ALL_PROXY= https_proxy= HTTP_PROXY= http_proxy= NO_PROXY= no_proxy= ftp_proxy= FTP_PROXY= podman-compose up -d
else
	echo "Image \"${1}\" not found."
fi
exit