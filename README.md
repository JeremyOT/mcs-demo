# Multi-Cluster Services Demo

This demo shows what the Multi-Cluster Services API could look like, using a
hacky implementation.

1. Install [kind](https://kind.sigs.k8s.io/docs/user/quick-start/)
2. Clone my hacky branch of K8s 1.18 to $GOPATH/src/k8s.io/kubernetes:
```
git clone --single-branch --branch mcs https://github.com/JeremyOT/kubernetes.git $GOPATH/src/k8s.io/kubernetes
```
3. Build the image and create local clusters:
```
kind build node-image --type docker --image kindest/node:mc && ./up.sh
```
4. Run the demo
```
./demo/demo.sh
```
5. Clean up
```
./down.sh
```
