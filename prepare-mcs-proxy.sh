#!/bin/bash

set -e
set -x

TARGET_TAG="multicluster.x-k8s.io/kube-proxy"
ARCH=$(go env GOARCH)
KUBEROOT="${KUBEROOT:-$GOPATH/src/k8s.io/kubernetes}"

PROXY_IMAGE="${KUBEROOT}/_output/release-images/amd64/kube-proxy.tar"

if [ ! -f ${PROXY_IMAGE} ]; then
  pushd ${KUBEROOT}
  make quick-release-images
  popd
fi

BUILD_TAG=$(tar -xf ${PROXY_IMAGE} manifest.json --to-stdout | jq -r '.[0].RepoTags[0]')

docker load -i ${PROXY_IMAGE}
docker tag ${BUILD_TAG} ${TARGET_TAG}

