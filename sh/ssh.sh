#!/bin/bash
homeDir=~
ssh-keygen -f "${homeDir}/.ssh/known_hosts" -R "[127.0.1.1]:1122" 2> /dev/null > /dev/null
ssh root@127.0.1.1 -p 1122
exit