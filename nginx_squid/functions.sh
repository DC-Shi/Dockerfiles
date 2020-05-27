#!/bin/bash

DOCKER_IMG=""
DOCKER_CON=""
SELECT_VAL=""
SEARCH_KEYWORD="nginx"
timeout=5
TXT_L_R=$(tput setab 4)
TXT_NORMAL=$(tput sgr0)


function echoHightlight {
  echo "${TXT_L_R}$@${TXT_NORMAL}"
}

function Select {
  local arr=("$@")
  if [ ${#arr[@]} -eq 0 ]  # No entry found
  then
    echo "'${SEARCH_KEYWORD}' not found!"
    exit 1
  elif [ ${#arr[@]} -eq 1 ]  # Only one image, use by default
  then
    echo "Found only one: ${arr}"
    SELECT_VAL=${arr}
    return 0
  fi

  echo "---------------------------"
  printf "Index\t ======\t Name\n"
  # Loop over each index
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

# Generate container name without conflict
function GenerateName {
  local basename=$1
  local name="$basename"
  local i=""
  # check the name is conflict
  while true
  do
    docker inspect $name 1>/dev/null 2>/dev/null
    if [ $? -eq 0 ] # Found container with name
    then
      echo Container with \"$name\" is found!
      name="${basename}_i"
    else
      echo \"$name\" can be used!
      break
    fi
  done
}

function GetImage {
    SEARCH_KEYWORD="$1"
    # Get array of images/containers
    mapfile -t ARR_IMG < <(docker images | grep ${SEARCH_KEYWORD} | awk '{print $1 ":" $2}')

    # Select which image to use
    Select "${ARR_IMG[@]}"
    DOCKER_IMG=$SELECT_VAL
    echoHightlight "[Choice made] Using image: $DOCKER_IMG"
}

function GetContainer {
    SEARCH_KEYWORD="$1"
    # Get array of images/containers
    mapfile -t ARR_CON < <(docker ps -a | grep ${SEARCH_KEYWORD} | awk '{print $1 ":" $2 ", " $(NF)}')

    # Select which image to use
    Select "${ARR_CON[@]}"
    DOCKER_CON=$SELECT_VAL
    echoHightlight "[Choice made] Using container: $DOCKER_CON"
}

# Start the container
# Parameters:
# 1st param must be container name
# Other params are sent directly to docker command.
function ContainerRun {
  # Logic:
  # 1. If no container exists, start in background
  # 2. container running, attach to it.
  # 3. otherwise, restart container.
  name="$1"
  if [ "$(docker ps -aq -f name=${name})" ]
  then
    echo "Container ${name} exists"
    if [ "$(docker ps -aq -f status=running -f name=${name})" ]
    then
      echo "Container ${name} is running, do nothing."
      #docker container attach "$name"
    else
      echo "Container status: $(docker inspect -f '{{.State.Status}}' ${name}), will restart."
      docker container restart "$name"
    fi
    
  else
    echo "Starting container ${name} in background."
    nvidia-docker run -d --name "$@"
      
  fi
}


function main() {
    GetImage "test"
    GetContainer "dao"
}

if [ "${1}" != "--source-only" ]; then
    main "${@}"
fi