# Steam for Linux in Docker
Mount your library and you can play steam games in docker!

# 1. Build the docker
Pull the repo, enter the directory, and run `bash build.sh`

# 2. Run the container!
Before starting the container, make sure you can run container with GPU. Please follow https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html if you have a clean system for installing container toolkit.

Execute the bash script `bash run.sh`

It will automatically search any "steam" related images and you can choose one if multiple images found. You may want to modify `PROFILE_DIR` variable to your folder.

# 3. Inside container
Run `steam` would download the newest client and you can login after client got updated.

# Tested Host
- NVIDIA GPU driver version: 470.82.00
- Ubuntu 20.04.3 is tested

# Bugs
Do not use 'remember my password' when login
