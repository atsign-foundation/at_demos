#!/bin/bash

# Ask user for sshnp atSign
echo "Enter your sshnp atSign (e.g. \"@sshnp\"):"
read sshnp

# check if `sshnp` starts with `@`
if [[ $sshnp != @* ]]
then
    echo "sshnp atSign must start with \"@\""
    exit 1
fi

# Ask user for sshnpd atSign
echo "Enter your sshnpd atSign (e.g. \"@sshnpd\"):"
read sshnpd

# check if `sshnpd` starts with `@`
if [[ $sshnpd != @* ]]
then
    echo "sshnpd atSign must start with \"@\""
    exit 1
fi

# Ask user for sshrvd atSign
echo "Enter your sshrvd atSign (e.g. \"@sshrvd\"):"
read sshrvd

# check if `sshrvd` starts with `@`
if [[ $sshrvd != @* ]]
then
    echo "sshrvd atSign must start with \"@\""
    exit 1
fi

# Ask user for email
echo "Enter your email (optional, Enter to skip):"
read email

# Ask user for deviceName
echo "Enter your device name (optional, Enter to skip):"
read deviceName

# replace `<@sshnp>` with `sshnp` in sshnp/.startup.sh and sshnpd/.startup.sh
sed -ri "" "s/<@sshnp>/$sshnp/g" sshnp/.startup.sh
sed -ri "" "s/<@sshnp>/$sshnp/g" sshnpd/.startup.sh

# replace `<@sshnpd>` with `sshnpd` in sshnp/.startup.sh and sshnpd/.startup.sh
sed -ri "" "s/<@sshnpd>/$sshnpd/g" sshnp/.startup.sh
sed -ri "" "s/<@sshnpd>/$sshnpd/g" sshnpd/.startup.sh

# replace `<@sshrvd>` with `sshrvd` in sshnp/.startup.sh and sshrvd/.startup.sh
sed -ri "" "s/<@sshrvd>/$sshrvd/g" sshnp/.startup.sh
sed -ri "" "s/<@sshrvd>/$sshrvd/g" sshrvd/.startup.sh

# replace `john@example.com` with `email` in sshnp/.startup.sh and sshrvd/.startup.sh
sed -ri "" "s/john@example.com/$email/g" sshnp/.startup.sh
sed -ri "" "s/john@example.com/$email/g" sshrvd/.startup.sh

# replace`<deviceName>` with `deviceName` in sshnp/.startup.sh and sshnpd/.startup.sh
sed -ri "" "s/<deviceName>/$deviceName/g" sshnp/.startup.sh
sed -ri "" "s/<deviceName>/$deviceName/g" sshnpd/.startup.sh