#!/bin/bash
shx buildAll
rm -v build/photon-amd64.tar* 2>/dev/null
podman export -o "build/photon-amd64.tar" photon_gel_1
lzip -v9 build/photon-amd64.tar
exit