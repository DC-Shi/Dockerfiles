# Description
Start nginx container and squid container.

# Prerequisites
```bash
#If you want to run nginx, you need pull the container:
docker pull nginx
#If you want to run squid, you need pull the container:
docker pull sameersbn/squid
```

# File table

Filename | type | description
---------|------|----
`functions.sh` | script  | Functions used by scripts
`nginx.sh` | mapping port 80(container) to 1280(host) | Start nginx container
`nginx/sample.pac` | config  | Sample pac file
`README.md` | text  | This readme file
`squidconf` | config  | Sample squid config
`squid.sh` | mapping port 3128(container) to 13128(host) | Start squid container
(`squid`) | folder | Auto created by squid

# Tested Host
- Ubuntu 16.04.5
- Docker version 18.09.0, build 4d60db4

# Reference
Docker image used: [nginx](https://hub.docker.com/_/nginx), [squid](https://hub.docker.com/r/sameersbn/squid)
