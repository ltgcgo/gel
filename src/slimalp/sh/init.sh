#!/bin/sh
apk update
apk add bash zsh shadow
sed -i "s/root:x:0:0:root:\/root:\/bin\/ash/root:x:0:0:root:\/root:\/bin\/zsh/g" /etc/passwd
exit