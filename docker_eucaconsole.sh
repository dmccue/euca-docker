#!/bin/bash
# David McCue 2015
echo Setup environment...
eval "$(boot2docker shellinit)"
echo
echo Rebuilding docker container...
docker rm -f eucaconsole &>/dev/null
docker build -t eucalyptus/console:latest -f Dockerfile.eucaconsole .
docker run -d -e clchost=$(vagrant ssh-config | grep HostName | cut -d' ' -f4) --name eucaconsole -P eucalyptus/console
url_ip="$(boot2docker ip)"
url_port="$(docker port eucaconsole 8888/tcp | sed 's/.*://')"
echo
nc -zw5 ${url_ip} ${url_port} && echo Info: GUI online || echo Info: GUI offline
echo
echo "******** Info: Please connect to: http://${url_ip}:${url_port} ********"
echo "Info: To access shell of eucaconsole container please run: docker exec -it eucaconsole bash"
echo
docker logs -f eucaconsole