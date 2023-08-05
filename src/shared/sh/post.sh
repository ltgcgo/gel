#!/bin/bash
cd $PREFIX/root/sh/shared
bash syncSkel.sh
rm -rf $PREFIX/var/log
mkdir -p $PREFIX/var/log
rm -rf $PREFIX/root/sh
exit
