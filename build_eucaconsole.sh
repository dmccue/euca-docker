#!/bin/bash

docker build -t eucalyptus/eucaconsole:latest -f Dockerfile.eucaconsole .
docker login -u eucalyptus
docker push eucalyptus/eucaconsole:latest


