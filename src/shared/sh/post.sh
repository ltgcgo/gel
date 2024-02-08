#!/bin/bash
cd $PREFIX/root/gel/shared/sh
bash syncSkel.sh
rm -rf $PREFIX/var/log
mkdir -p $PREFIX/var/log
#rm -rf $PREFIX/root/sh
exit
