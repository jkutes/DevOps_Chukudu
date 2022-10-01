#!/bin/bash -x

# exit on error
set -e 

STATEFULLSET="Litecoin-k8s-Statefulset.yaml"
SERVICE="Litecoin-service.yaml"
SECRET="secret.yaml"

# start minikube for testing
# minikube delete

minikube start

#debug minikube
#minikube start --v=5
# set local docker, important when not pulling images from DockerHub, just locally 
#eval $(minikube docker-env)
systemctl enable kubelet.service

# set alias for kubectl for jenkinss
alias kubectl="minikube kubectl --"

# get storage class list
kubectl get storageclass
# list presistance volumes
kubectl get pv
# list presistance volume claims
kubectl get pvc

# cleanup
kubectl delete -f $STATEFULLSET
kubectl delete -f $SERVICE
kubectl delete -f $SECRET

# apply secret
# using simple secrect here, but we would use hashiCorp Vault instead
kubectl apply -f $SECRET

# get secret
kubectl get secrets

# apply stateful set
kubectl apply -f $STATEFULLSET

# check on the statefulset
kubectl describe statefulset litecoin 

# Get list of pods
kubectl get pods -w -l app=litecoin

# apply service
kubectl apply -f $SERVICE

# Get the list of running services
kubectl get svc

# access
#kubectl exec -it litecoin /bin/sh
