#!/bin/bash
export MODE_NATIVE=1
cd ~/gel/
echo "Setting up Gel in a native environment."
echo "Copying shared config files..."
cp -rv shared/etc/* /etc/
echo "Copying distro config files..."
cp -rv distro/etc/* /etc/
echo "Running shared setup scripts..."
cd shared/sh
bash setup.sh
echo "Running distro setup scripts..."
cd ../../distro/sh
bash setup.sh
if [ -f "./native.sh" ] ; then
	echo "Running native setup scripts..."
	bash native.sh
else
	echo "No native setup scripts found."
fi
echo "Running post-installation shared scripts..."
cd ../../shared/sh
bash post.sh
exit
