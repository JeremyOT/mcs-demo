# Multi-Cluster Services Demo

This demo shows what the Multi-Cluster Services API could look like, using a
hacky implementation.

1. Install [kind](https://kind.sigs.k8s.io/docs/user/quick-start/)
2. Get the API library
```
go get github.com/JeremyOT/mcs-api
```
3. Clone my hacky branch of K8s 1.18 to $GOPATH/src/k8s.io/kubernetes.
```
git clone --single-branch --branch mcs-crd https://github.com/JeremyOT/kubernetes.git $GOPATH/src/k8s.io/kubernetes
```
4. Build the alternative MCS proxy and prepare it for use. This assumes
   the mcs-crd branch is installed in your $GOPATH as k8s.io/kubernetes an
   will build images if not already present. Set `$KUBEROOT` if using another
   location.
```
./prepare-mcs-proxy.sh
```
5. Create local clusters, connect their networks, and enable Multi-Cluster
   Services.
```
./up.sh
```
6. Run the demo
```
./demo/demo.sh
```
7. Clean up
```
./down.sh
```
