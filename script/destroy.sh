#!/bin/bash

# Completely destory all networks, volumes, and containers associated with the app

set -uo pipefail

ROOT=$(cd $(dirname $0)/.. && pwd)

source ${ROOT}/script/include/constants.sh
source ${ROOT}/script/include/util.sh

docker rm -fv $(docker ps -aq -f name=${APP})


if image_exists etoews/interlock:templates ; then
  docker rmi etoews/interlock:templates
fi

if image_exists ${INTERLOCK_IMAGE} ; then
  docker rmi ${INTERLOCK_IMAGE}
fi

if network_exists ${NETWORK} ; then
  docker network rm ${NETWORK}
fi
