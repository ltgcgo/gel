#!/usr/bin/bash
cprefix="../../configs"
if [ "$(whoami)" == "root" ] ; then
	cp -nv $PREFIX/etc/skel/.zshrc ~/.zshrc
	chsh -s /bin/zsh && echo "Default shell switched to ZSH."
	if [ -e "$PREFIX/home" ] ; then
		echo "Copying ZSH default configuration to every applicable user..."
		ls -1 $PREFIX/home | while IFS= read -r curUser; do
			printf "Detecting legimacy of user [$curUser]... "
			if [ -e "$PREFIX/home/$curUser/.bashrc" ] ; then
				cpOk="0"
				echo "real."
				printf "Copying configuration... "
				if [ -e "$PREFIX/home/$curUser/.zshrc" ] ; then
					echo "skipped."
				else
					cp -nr $cprefix/SystemEtc/skel/.* "$PREFIX/home/$curUser/"
					echo "success."
					echo "Forcing ZSH usage for user [$curUser] ..."
					chsh $curUser -s $(which zsh)
				fi
			else
				echo "fake. Skipping..."
			fi
		done
	else
		echo "No applicable users."
	fi
else
	echo "This script must be run as root."
fi
