#!/bin/bash
DOCKERFILE="${1}"
[ -z "${1}" ] && { echo Error: Please enter dockerfile suffix as arg1, also use -p to push build to dockerhub; exit 1; }
TAG=$(cat ${DOCKERFILE} | sed -En 's/.*#tag (.*)$/\1/p')

[ "${2}" == "nocache" ] && CACHE="--no-cache=true"

[ -e "${DOCKERFILE}" ] || { echo Error: File ${DOCKERFILE} not found; exit 1; }
[ -z "${TAG}" ] && { echo Error: TAG not found, please add a \#tag statement; exit 1; }
echo Info: Will assign tag: ${TAG} once successfully built
echo Info: Running: docker build -t ${TAG} -f ${DOCKERFILE} .

docker build -t ${TAG} -f ${DOCKERFILE} . || { echo Error: Build did not complete successfully; exit 1; }

[ "${2}" == "-p" ] \
&& { docker login -u eucalyptus && docker push ${TAG} && exit 0; }
