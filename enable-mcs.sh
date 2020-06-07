#!/bin/bash

cd $(dirname ${BASH_SOURCE})

KUBEROOT="${KUBEROOT:-$GOPATH/src/k8s.io/kubernetes}"

C=${1}

kubectl --context "kind-${C}" apply -f $KUBEROOT/vendor/k8s.io/mcs-api/pkg/apis/multicluster/v1alpha1/serviceimport.yaml
kubectl --context "kind-${C}" apply -f $KUBEROOT/vendor/k8s.io/mcs-api/pkg/apis/multicluster/v1alpha1/serviceexport.yaml

