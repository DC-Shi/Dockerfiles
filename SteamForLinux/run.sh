#!/bin/bash

DOCKER_IMG=""
SELECT_VAL=""
STEAM_KEYWORD="steam"
CONTAINER_NAME="steam_games"
timeout=5
TXT_L_R=$(tput setab 4)
TXT_NORMAL=$(tput sgr0)

# Get array of images
mapfile -t ARR_IMG < <(docker images | grep ${STEAM_KEYWORD} | awk '{print $1 ":" $2}')

# echo with highlight
function echoHighlight {
  echo "${TXT_L_R}$@${TXT_NORMAL}"
}

# Select one options
# Arg1: array of options
function Select {
  local arr=("$@")
  if [ ${#arr[@]} -eq 0 ]  # No entry found
  then
    echo "'${STEAM_KEYWORD}' related not found!"
    exit 1
  elif [ ${#arr[@]} -eq 1 ]  # Only one image, use by default
  then
    echo "Found only one: ${arr}"
    SELECT_VAL=${arr}
    return 0
  fi

  echo "---------------------------"
  printf "Index\t ======\t Name\n"
  # Loop over each index and print
  for idx in "${!arr[@]}"
  do
    printf "${idx}\t ======\t ${arr[$idx]}\n"
  done

  # Read the choice
  read -p "Please select one image in $timeout secs: " -t $timeout idx_select
  # Default choice behaviour
  if [ -z "$idx_select" ]
  then
    echo "Select nothing, using first by default"
  else
    echo #"You selected $idx_select"
  fi
  SELECT_VAL=${arr[$idx_select]}
}


# Select which image to use
Select "${ARR_IMG[@]}"
DOCKER_IMG=$SELECT_VAL
echoHighlight "[Choice made] Using image: $DOCKER_IMG"

# Test for menu select
#exit 0

PROFILE_DIR=$(readlink -f ~/steam_profile/steam_home)
USER_ID=$(id -u)

# Enable display for container
xhost +local:root
# Start container
docker run --rm \
  -it \
  --gpus all \
  --name ${CONTAINER_NAME} \
  --net=host \
  --shm-size 8G \
  -e DISPLAY \
  -v ${HOME}/.Xauthority:/home/steam/.Xauthority \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  --device /dev/dri/renderD128 \
  --device /dev/dri/card0 \
  --device /dev/snd \
  --volume=/run/user/${USER_ID}/pulse:/run/user/${USER_ID}/pulse \
  -v ~/.config/pulse/cookie:/run/pulse/cookie \
  --volume=${PROFILE_DIR}:/home/steam/ \
  -e PULSE_SERVER=/run/user/${USER_ID}/pulse/native \
  -e PULSE_COOKIE=/run/pulse/cookie \
  -w=/home/steam \
  ${DOCKER_IMG} 


# Disable 
xhost -local:root
