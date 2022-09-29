#!/bin/bash
# show error line and exit on no zero return
set -e 

# set vars
IMAGE="devopschuduku/litecoin"
TAG="0.18.1"
IMGID=$(docker images|grep ${IMAGE}|grep ${TAG}|awk '{print $3}')

# delete existing litecoin image in case it already exists
echo "Removing Litecoin image in case it exists already"
docker rmi $IMGID 

#build
echo 
echo "Buildeing Litecoin"
docker build -t $IMAGE:$TAG --no-cache -f Dockerfile .

#list litecoin images
echo 
echo "Listing current Litecoin images"
docker image ls|grep $IMAGE