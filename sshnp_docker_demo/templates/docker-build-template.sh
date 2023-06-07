#!/bin/bash

#
# DO NOT RUN THIS SCRIPT. THIS IS MEANT TO BE RUN BY ANOTHER SCRIPT IN ONE OF THE TWO DIRECTORIES
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

TYPE=${1}
BASE_IMAGE_NAME=atsigncompany/sshnp_docker_demo_base
CUSTOM_IMAGE_NAME=atsigncompany/sshnp_docker_demo_${TYPE}
CONTAINER_NAME=sshnp_docker_demo_${TYPE}
NETWORK_NAME=sshnp_docker_demo_network_${TYPE}

# try to docker pull, if it doesn't work, build local image
# sudo docker pull $BASE_IMAGE_NAME
# if [ $? -ne 0 ]
# then
#     echo "Could not pull $BASE_IMAGE_NAME. Building local image."
    sudo docker build -t $BASE_IMAGE_NAME -f ../demo-base/Dockerfile ../demo-base
# fi

# create device network
sudo docker network rm $NETWORK_NAME
sudo docker network create --driver=bridge $NETWORK_NAME
sudo docker build -t $CUSTOM_IMAGE_NAME .
sudo docker stop $CONTAINER_NAME
sudo docker container rm $CONTAINER_NAME
sudo docker run -it --name $CONTAINER_NAME --network=$NETWORK_NAME $CUSTOM_IMAGE_NAME
