#!/bin/bash

set -ueo pipefail

ROOT=$(cd $(dirname $0)/.. && pwd)

source ${ROOT}/script/include/constants.sh
source ${ROOT}/script/include/util.sh

# TODO check for DOCKER_HOST and link to create connect cluster or virtualbox

for (( i=1; i<=2; i++ )); do
  echo "Build image ${INTERLOCK_IMAGE}${i}"

  sed s#DOCKER_HOST#${DOCKER_HOST}#g interlock/config.tmpl > interlock/config.tmpl2
  sed s#SERVICE_NAME#service${i}#g interlock/config.tmpl2 > interlock/config.toml

  docker build \
    --build-arg constraint:node==*n${i} \
    --tag ${INTERLOCK_IMAGE}${i} \
    interlock/

  rm interlock/config.tmpl2

  if ! network_exists ${NETWORK}${i} ; then
    echo "Create network ${NETWORK}${i}"
    docker network create ${NETWORK}${i}
  fi

  if ! container_exists ${INTERLOCK}${i} ; then
    echo "Run container ${INTERLOCK}${i}"
    docker run --detach \
      --name ${INTERLOCK}${i} \
      --net ${NETWORK}${i} \
      --label interlock.ext.service.name=service${i} \
      --restart unless-stopped \
      --volumes-from swarm-data:ro \
      --env constraint:node==*n${i} \
      ${INTERLOCK_IMAGE}${i} \
      -D run --config /etc/interlock/config.toml
  fi
done

# This is in a bash script because --volumes-from swarm-data:ro ????
# https://github.com/docker/compose/issues/2958
# https://github.com/docker/compose/issues/3077
