#!/bin/bash

# Load functions for selecting
source ./functions.sh --source-only

# Select which image to use
GetImage "sameersbn/squid"
DOCKER_IMG=$SELECT_VAL

SHAREDSRC=$(readlink -f .)

# Start container
echo docker run --rm \
  -it \
  --name "squid_test" \
  --publish 13128:3128 \
  --volume ${SHAREDSRC}/squid:/var/spool/squid \
  -v ${SHAREDSRC}/squidconf:/etc/squid/squid.conf \
  ${DOCKER_IMG} -X
