#!/bin/bash

# Load functions for selecting
source ./functions.sh --source-only

# Select which image to use
GetImage "nginx"
DOCKER_IMG=$SELECT_VAL

SHAREDSRC=$(readlink -f ./nginx/)

# Start container
echo docker run --rm \
  -it \
  --name "nginx_test" \
  -p 1280:80 \
  -v ${SHAREDSRC}:/usr/share/nginx/html \
  --shm-size 8G \
  ${DOCKER_IMG} 


