#!/bin/bash
ssh-keygen -A
/usr/sbin/sshd -D -o "ListenAddress 127.0.0.1" -o "PasswordAuthentication no"  &
while true
do
sudo -u atsign /atsign/sshnp/sshnpd -a @sshnpd -m @sshnp -d deviceName -s -u -v
sleep 3
done