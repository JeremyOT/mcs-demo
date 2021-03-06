#!/bin/bash

cd $(dirname ${BASH_SOURCE})
. ./util.sh

function dryrun() {
  maybe_first_prompt
  rate=25
  echo "$green$1$reset" | pv -qL $rate
  read -d '' -t "${timeout}" -n 10000 # clear stdin
  prompt
  if [ -z "$DEMO_AUTO_RUN" ]; then
    read -s
  fi
}


C1="kind-a"
C2="kind-b"

DEMO_AUTO_RUN=true

kubectl --context ${C1} apply -f demo-namespace.yaml
kubectl --context ${C2} apply -f demo-namespace.yaml

desc "Deploy the demo service and pinger app..."
run "kubectl --context ${C1} apply -f yaml/demo-service-a.yaml"
run "kubectl --context ${C1} apply -f yaml/pinger.yaml"
run "kubectl --context ${C2} apply -f yaml/demo-service-b.yaml"
run "kubectl --context ${C2} apply -f yaml/pinger.yaml"

PINGER_A=$(kubectl --context ${C1} get pods -n demos -l app=pinger -o go-template --template="{{(index .items 0).metadata.name}}")
PINGER_B=$(kubectl --context ${C2} get pods -n demos -l app=pinger -o go-template --template="{{(index .items 0).metadata.name}}")

sleep 3

desc "Show requests from ${C1}"
run "kubectl --context ${C1} logs -n demos ${PINGER_A} --tail 10"

desc "Show requests from ${C2}"
run "kubectl --context ${C2} logs -n demos ${PINGER_B} --tail 10"

desc "Copy EndpointSlices between clusters..."

run "kubectl --context ${C1} get endpointslice -n demos"
run "kubectl --context ${C2} get endpointslice -n demos"

EP_1=$(kubectl --context ${C1} get endpointslice -n demos --template="{{(index .items 0).metadata.name}}")
EP_2=$(kubectl --context ${C2} get endpointslice -n demos --template="{{(index .items 0).metadata.name}}")

DEMO_RUN_FAST=true

run "kubectl --context ${C1} get endpointslice -n demos ${EP_1} -o yaml | ./edit_meta --metadata '{name: imported-${EP_1}, namespace: demos, labels: {multicluster.kubernetes.io/service-name: demo}}' > yaml/cluster-a-epslice.yaml"
run "kubectl --context ${C2} get endpointslice -n demos ${EP_2} -o yaml | ./edit_meta --metadata '{name: imported-${EP_2}, namespace: demos, labels: {multicluster.kubernetes.io/service-name: demo}}' > yaml/cluster-b-epslice.yaml"
run "kubectl --context ${C1} apply -f yaml/cluster-b-epslice.yaml"
run "kubectl --context ${C1} apply -f yaml/cluster-a-epslice.yaml"
run "kubectl --context ${C2} apply -f yaml/cluster-b-epslice.yaml"
run "kubectl --context ${C2} apply -f yaml/cluster-a-epslice.yaml"
run "kubectl --context ${C1} get endpointslice -n demos"
run "kubectl --context ${C2} get endpointslice -n demos"
sleep 1
DEMO_RUN_FAST=''

desc 'Now the "Controller" creates the ServiceImport'

cat yaml/service-import.yaml | grep -E -e '^' -e '([0-9]+\.)+[0-9]+'

run "kubectl --context ${C1} apply -f yaml/service-import.yaml"
run "kubectl --context ${C2} apply -f yaml/service-import.yaml"

desc "Show requests from ${C1} (no change)"
run "kubectl --context ${C1} logs -n demos ${PINGER_A} --tail 10"

desc "Show requests from ${C2} (no change)"
run "kubectl --context ${C2} logs -n demos ${PINGER_B} --tail 10"

desc "Point pinger at the supercluster IP"

run "kubectl --context ${C1} get deployment -n demos pinger -o yaml | sed 's/demo.demos.svc.cluster.local/10.42.42.42/' | kubectl --context ${C1} apply -f -"
run "kubectl --context ${C2} get deployment -n demos pinger -o yaml | sed 's/demo.demos.svc.cluster.local/10.42.42.42/' | kubectl --context ${C2} apply -f -"
sleep 3

PINGER_A=$(kubectl --context ${C1} get pods -n demos -l app=pinger -o go-template --template="{{(index .items 0).metadata.name}}")
PINGER_B=$(kubectl --context ${C2} get pods -n demos -l app=pinger -o go-template --template="{{(index .items 0).metadata.name}}")

desc "Show requests from ${C1}"
run "kubectl --context ${C1} logs -n demos ${PINGER_A} --tail 10"

desc "Show requests from ${C2}"
run "kubectl --context ${C2} logs -n demos ${PINGER_B} --tail 10"
