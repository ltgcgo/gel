#!/bin/bash
dnf update -y
dnf install -y 'dnf-command(config-manager)'
dnf config-manager --set-enabled crb
dnf install -y epel-release
dnf install -y util-linux-user which zsh
exit
