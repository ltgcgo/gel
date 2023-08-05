#!/bin/bash
dnf update -y
dnf install -y epel-release
dnf install -y util-linux-user which zsh
exit
