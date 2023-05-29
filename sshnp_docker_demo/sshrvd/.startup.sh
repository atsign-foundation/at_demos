#!/bin/bash
ssh-keygen -A
ssh-keygen -o -a 100 -t ed25519 -f /atsign/.ssh/id_ed25519 -C "john@example.com"
/usr/sbin/sshd -D -o "ListenAddress 127.0.0.1" -o "PasswordAuthentication no"  &
while true
do
sudo -u atsign /atsign/sshnp/sshrvd -a @sshrvd -i <ip> -v -s
sleep 3
done