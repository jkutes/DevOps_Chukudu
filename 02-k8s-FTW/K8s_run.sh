#!/bin/bash -x


# start minikube for testing
minikube start
# set local docker, important when not pulling images from DockerHub, just locally 
#eval $(minikube docker-env)

# set alias for kubectl for jenkinss
alias kubectl="minikube kubectl --"

# get storage class list
kubectl get storageclass
# list presistance volumes
kubectl get pv
# list presistance volume claims
kubectl get pvc

# cleanup
kubectl delete -f Litecoin-k8s-Statefulset.yaml
kubectl delete -f Litecoin-service.yaml
kubectl delete -f secret.yaml

# apply secret
# using simple secrect here, but we would use hashiCorp Vault instead
kubectl apply -f secret.yaml

# get secret
kubectl get secrets

# apply stateful set
kubectl apply -f Litecoin-k8s-Statefulset.yaml

# check on the statefulset
kubectl describe statefulset litecoin 

# Get list of pods
kubectl get pods -w -l app=litecoin

# apply service
kubectl apply -f Litecoin-service.yaml

# Get the list of running services
kubectl get svc

# access
#kubectl exec -it litecoin /bin/sh