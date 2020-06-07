# Multi-Cluster Services Demo

This demo shows what the Multi-Cluster Services API could look like, using a
hacky implementation.

1. Install [kind](https://kind.sigs.k8s.io/docs/user/quick-start/)
2. Clone my hacky branch of K8s 1.18 to $GOPATH/src/k8s.io/kubernetes.
```
git clone --single-branch --branch mcs-crd https://github.com/JeremyOT/kubernetes.git $GOPATH/src/k8s.io/kubernetes
```
3. Build K8s with MCS support. This assumes the mcs-crd branch is installed
   in your $GOPATH as k8s.io/kubernetes. Set `$KUBEROOT` if using another
   location.
```
./prepare-mcs-proxy.sh
```
4. Create local clusters, connect their networks, and enable Multi-Cluster
   Services by installing the MCS CRDs.
```
./up.sh
```
5. Run the demo
```
./demo/demo.sh
```
6. Clean up
```
./down.sh
```
