#!/bin/bash
echo "glibc compatibility will only work on amd64 architecture."
case $(uname -m) in
	"x86_64" | "amd64")
		echo "amd64 detected."
		;;
	*)
		echo "Not on amd64. The script will now exit."
		exit 1
		;;
esac
curl -Lo glibc.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r1/glibc-2.35-r1.apk"
curl -Lo glibc-bin.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r1/glibc-bin-2.35-r1.apk"
apk add glibc.apk glibc-bin.apk
exit