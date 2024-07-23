#!/bin/bash
shx buildAll
podman save -o "build/photon-amd64.tar" photon_gel_1
lzip -v9 build/photon-amd64.tar
exit