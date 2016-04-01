#!/bin/bash

# Completely destory all networks, volumes, and containers associated with the app

set -uo pipefail

ROOT=$(cd $(dirname $0)/.. && pwd)

source ${ROOT}/script/include/constants.sh
source ${ROOT}/script/include/util.sh

docker rm -fv $(docker ps -aq -f name=${APP})

if image_exists etoews/interlock:multi ; then
  docker rmi etoews/interlock:multi
fi

for (( i=1; i<=2; i++ )); do
  if image_exists ${INTERLOCK_IMAGE}${i} ; then
    docker rmi ${INTERLOCK_IMAGE}${i}
  fi

  if network_exists ${NETWORK}${i} ; then
    docker network rm ${NETWORK}${i}
  fi
done
