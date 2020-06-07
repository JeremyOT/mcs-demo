#!/bin/bash

cd $(dirname ${BASH_SOURCE})

C=${1}

kubectl --context "kind-${C}" delete crd serviceimports.multicluster.k8s.io
kubectl --context "kind-${C}" delete crd serviceexports.multicluster.k8s.io

