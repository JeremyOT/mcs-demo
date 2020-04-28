kubectl config use kind-a
$(dirname ${BASH_SOURCE})/reset.sh

kubectl config use kind-b
$(dirname ${BASH_SOURCE})/reset.sh
