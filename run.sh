#!/bin/bash

valid_args="all|base|console|clc|sc|nc|cc|walrus"
DOCKER_IP=$(boot2docker ip)
echo -n ${1} | grep "^[${valid_args}]" || { echo please specify one of ${valid_args}; exit 1; }

./build.sh Dockerfile.${1} && echo Build successful
docker rm -f ${1} &>/dev/null
case "${1}" in
    clc )
        docker run --name=${1} -dP --privileged=true eucalyptus/${1}
        #docker run --name=${1} -dP eucalyptus/${1}
        ;;
    console )
        docker run --name=${1} -dP -e clc=${DOCKER_IP}:$(docker port clc 8773/tcp | sed 's/.*://') eucalyptus/${1}
        echo Please connect to address: $(docker port ${1} | sed 's/.*0.0.0.0:/http:\/\/${DOCKER_IP}:/')
        #ufs api endpoint is included
        ;;
    cc )
        docker run --name=${1} -dP --privileged=true eucalyptus/${1}
        #docker port cc 8774/tcp
        ;;
    walrus )
        docker run --name=${1} -dP eucalyptus/${1}
        ;;
    sc )
        docker run --name=${1} -dP eucalyptus/${1}
        ;;
esac
