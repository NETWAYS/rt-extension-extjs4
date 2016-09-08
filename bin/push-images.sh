
#!/bin/bash
BIN_DIR=$(cd $(dirname $0); pwd)
TAG_BASE=${TAG_BASE:-"net-docker-registry.adm.netways.de:5000"}

. $BIN_DIR/functions.sh

cd $BASE_DIR

IMAGES=$(docker images --format "{{.ID}}:{{.Repository}}" | grep -e ':rt4\/')
for I in $IMAGES
do
  if [[ $I =~ ([^:]+):(.+) ]]
  then
    IMAGE=${BASH_REMATCH[1]}
    REPO=${BASH_REMATCH[2]}
    TAG="$TAG_BASE/$REPO"
    echo " -> Tag image $IMAGE as $TAG"
    docker tag $IMAGE $TAG
    echo " -> Push $TAG"
    docker push $TAG
    echo " -> DONE"
    echo ""
  fi
done
