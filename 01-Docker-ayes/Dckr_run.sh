#!/bin/bash -x

# change Volume "/data" path to your needs.

# show error line and exit on no zero return
# set -e 

# set vars
IMAGE="jkutes/litecoin"
CONT="litecoind"
NET="litecoin"
TAG="0.18.1"
IMGID=$(docker images|grep ${IMAGE}|grep ${TAG}|awk '{print $3}')
CONTID=$(docker ps -a|grep ${IMGID}|awk '{print $1}')
VOL="/tmp/data"

# delete existing litecoin image in case it already exists
echo "Removing Litecoin container in case it exists already"
[[ ! -z $CONTID ]] && (docker stop $CONTID; docker rm $CONTID) || echo "No container found"
echo
echo "Removing Litecoin image in case it exists already"
[[ ! -z $IMGID ]] && docker rmi $IMGID || echo "no image found"

# build
echo 
echo "Buildeing Litecoin"
docker build -t $IMAGE:$TAG --no-cache -f Dockerfile . || (echo "Build failed exiting"; exit 2)

# inline scan
echo 
echo "Inline Scan Anchore"
curl -s https://ci-tools.anchore.io/inline_scan-v0.6.0 | bash -s -- -f -d Dockerfile -b $PWD/.anchore_policy.json $IMAGE:$TAG


# push to DockerHub as to pull it later from k8s
docker login
docker push $IMAGE:$TAG

# list litecoin images
echo 
echo "Listing current Litecoin images"
docker image ls|grep $IMAGE

# run - with presistance volume and dedicated network
# create network
docker network create $NET
NEWIMGID=$(docker images|grep ${IMAGE}|grep ${TAG}|awk '{print $3}')
echo 
echo "Running"
docker run -d --rm --name $CONT -v "$VOL:/data" --network $NET $NEWIMGID
#sudo ls -alh $VOL

echo 
echo "Listing litecoin containers"
docker ps | grep $CONT
echo
echo "trail logs"
[[ $(whoami) == "jenkins" ]] && docker logs --follow --until=5s $CONT || docker logs -f $CONT
# trail logs only for 5 seconds if running as jenkins (for pipeline not to wait ) otherwise just trail

# access to debug
# docker exec -it $CONTID /bin/bash
