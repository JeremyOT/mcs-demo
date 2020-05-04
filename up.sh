#!/bin/bash

set -e
set -x

cd $(dirname ${BASH_SOURCE})

function add_routes() {
  unset IFS
  routes=$(kubectl --context "kind-${2}" get nodes -o jsonpath='{range .items[*]}ip route add {.spec.podCIDR} via {.status.addresses[?(.type=="InternalIP")].address}{"\n"}')
  echo "Connecting cluster ${1} to ${2}"

  IFS=$'\n'
  for n in $(kind get nodes --name "${1}"); do
    for r in $routes; do
      eval "docker exec $n $r"
    done
  done
  unset IFS
}

C1="a"
C2="b"

kind create cluster --config a.yaml --name ${C1}
kind create cluster --config b.yaml --name ${C2}

echo "Connecting cluster networks..."
add_routes ${C1} ${C2}
add_routes ${C2} ${C1}
echo "Cluster networks connected"


./enable-mcs.sh a
./enable-mcs.sh b

