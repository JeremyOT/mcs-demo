#!/bin/bash

cd $(dirname ${BASH_SOURCE})

TAG="multicluster.x-k8s.io/kube-proxy"

C=${1}

kubectl --context "kind-${C}" apply -f $GOPATH/src/github.com/JeremyOT/mcs-api/pkg/apis/multicluster/v1alpha1/serviceimport.yaml
kubectl --context "kind-${C}" apply -f $GOPATH/src/github.com/JeremyOT/mcs-api/pkg/apis/multicluster/v1alpha1/serviceexport.yaml

kind load docker-image ${TAG} --name ${C}

kubectl --context "kind-${C}" apply -f ./mcs-proxy.yaml

