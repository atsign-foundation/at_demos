#!/bin/bash
docker container prune -f
docker image prune -f
docker stop sshnpd
docker container rm sshnpd
docker image rm sshnpd
docker build -t sshnpd .
docker run -it --name sshnpd sshnpd