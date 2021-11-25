#!/bin/bash
# Replace the UID with current uid, then build the container


docker build --build-arg userID=$(id -u) -t steam_only .
