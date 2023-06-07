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

BASE_IMAGE_NAME=atsigncompany/sshnp_docker_demo_base
CUSTOM_IMAGE_NAME=atsigncompany/sshnp_docker_demo_$1
CONTAINER_NAME=sshnp_docker_demo_$1

sudo docker build -t $BASE_IMAGE_NAME -f ../demo-base/Dockerfile ../demo-base
sudo docker build -t $CUSTOM_IMAGE_NAME .
sudo docker stop $CONTAINER_NAME
sudo docker container rm $CONTAINER_NAME
sudo docker run -it --name $CONTAINER_NAME $CUSTOM_IMAGE_NAME
