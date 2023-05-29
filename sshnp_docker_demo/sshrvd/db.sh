#!/bin/bash
docker container prune -f
docker image prune -f
docker stop sshrvd
docker container rm sshrvd
docker build -t sshrvd .
docker run -it --name sshrvd sshrvd