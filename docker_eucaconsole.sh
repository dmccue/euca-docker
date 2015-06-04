#!/bin/bash

# Rebuild docker container
docker rm -f eucaconsole &>/dev/null
docker build -t eucalyptus/console:latest -f Dockerfile.eucaconsole .
docker run -d -e clchost=$(vagrant ssh-config | grep HostName | cut -d' ' -f4) --name eucaconsole -P eucalyptus/console

url_ip="$(boot2docker ip)"
url_port="$(docker port eucaconsole 8888/tcp | sed 's/.*://')"
echo "Info: Please connect to: http://${url_ip}:${url_port}"
echo "Info: To access shell of eucaconsole container please run: docker exec -it eucaconsole bash"
nc -zw1 ${url_ip} ${url_port}

docker logs -f eucaconsole
