#!/bin/bash

cd $(dirname ${BASH_SOURCE})

KUBEROOT="${KUBEROOT:-$GOPATH/src/k8s.io/kubernetes}"

C=${1}

kubectl --context "kind-${C}" apply -f $KUBEROOT/vendor/k8s.io/mcs-api/config/crds/multicluster.k8s.io_serviceexports.yaml
kubectl --context "kind-${C}" apply -f $KUBEROOT/vendor/k8s.io/mcs-api/config/crds/multicluster.k8s.io_serviceimports.yaml

