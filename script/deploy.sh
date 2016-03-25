#!/bin/bash

set -ueo pipefail

ROOT=$(cd $(dirname $0)/.. && pwd)

source ${ROOT}/script/include/constants.sh
source ${ROOT}/script/include/util.sh

# TODO check for DOCKER_HOST and link to create connect cluster or virtualbox

echo "Build image ${INTERLOCK_IMAGE}"
sed s#DOCKER_HOST#${DOCKER_HOST}#g interlock/config.tmpl > interlock/config.toml
docker build \
  --build-arg constraint:node==*n1 \
  --tag ${INTERLOCK_IMAGE} \
  interlock/

if ! network_exists ${NETWORK} ; then
  echo "Create network ${NETWORK}"
  docker network create ${NETWORK}
fi

if ! container_exists ${INTERLOCK} ; then
  echo "Run container ${INTERLOCK}"
  docker run -it \
    --name ${INTERLOCK} \
    --net ${NETWORK} \
    --restart unless-stopped \
    --volumes-from swarm-data:ro \
    --env constraint:node==*n1 \
    ${INTERLOCK_IMAGE} \
    -D run --config /etc/interlock/config.toml
fi
