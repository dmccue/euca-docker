#!/bin/bash


docker-machine rm -f test
docker-machine create --driver vmwarefusion \
   				--vmwarefusion-memory-size=2048 \
   				--vmwarefusion-boot2docker-url=https://github.com/cloudnativeapps/boot2docker/releases/download/v1.6.0-vmw/boot2docker-1.6.0-vmw.iso \
   				test
#  --vmwarefusion-boot2docker-url=file://$HOME/.boot2docker/boot2docker.iso \
/Applications/VMware\ Fusion.app/Contents/Library/vmrun readVariable ~/.docker/machine/machines/test/test.vmx runtimeConfig ip
/Applications/VMware\ Fusion.app/Contents/Library/vmrun readVariable ~/.docker/machine/machines/test/test.vmx runtimeConfig

eval $(docker-machine env test)
docker-machine ssh test -- docker version
docker ps
