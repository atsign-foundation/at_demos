#!/bin/bash
ssh-keygen -A
ssh-keygen -o -a 100 -t ed25519 -f /atsign/.ssh/id_ed25519 -C "john@example.com"
/usr/sbin/sshd -D -o "ListenAddress 127.0.0.1" -o "PasswordAuthentication no"  &
sudo -u atsign /atsign/sshnp/sshnp -f @soccer99 -t @66dear32 -h @48leo -d docker -s id_ed25519.pub -v
