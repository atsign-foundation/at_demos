#!/bin/bash
docker container prune -f
docker image prune -f
docker stop sshnp
docker container rm sshnp
docker image rm sshnp
docker build -t sshnp .
docker run -it --name sshnp sshnp