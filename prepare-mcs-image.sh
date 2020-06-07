#!/bin/bash

set -e
set -x

KUBEROOT="${KUBEROOT:-$GOPATH/src/k8s.io/kubernetes}"

kind build node-image --type docker \
  --image kindest/node:mc \
  --kube-root $KUBEROOT \
  --base-image kindest/base:v20200530-c3e2b553

