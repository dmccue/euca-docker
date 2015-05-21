#!/bin/bash

docker rm -f eucaconsole &>/dev/null
docker build -t eucalyptus/console:latest -f Dockerfile.eucaconsole .
docker run -d -e clchost=$(vagrant ssh-config | grep HostName | cut -d' ' -f4) --name eucaconsole -P eucalyptus/console

url_ip="$(boot2docker ip)"
url_port="$(docker port eucaconsole 8888/tcp | sed 's/.*://')"
echo "Please connect to http://${url_ip}:${url_port}"
nc -zw1 ${url_ip} ${url_port}

sleep 0.5
echo Docker time: $(docker exec -it eucaconsole date)
echo Local time: $(date)
echo Vagrant time: $(vagrant ssh -c date 2>/dev/null)

docker logs -f eucaconsole
