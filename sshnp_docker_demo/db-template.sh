#!/bin/bash

#
# DO NOT RUN THIS SCRIPT. THIS IS MEANT TO BE RUN BY ANOTHER SCRIPT IN ONE OF THE THREE DIRECTORIES
#

if [ -z "$1" ]
then
    echo "Usage: ./db.sh <sshnp/sshnpd/sshrvd>"
    exit 1
fi

# Check if keys/ contains at least one `.atKeys` file
if [ ! "$(ls -A keys/*.atKeys)" ]
then
    echo "No keys found in keys/ directory."
    exit 1
fi

rm Dockerfile
cp ../Dockerfile .
docker stop $1
docker container rm $1
docker build -t $1 .
docker run -it --name $1 $1
rm Dockerfile