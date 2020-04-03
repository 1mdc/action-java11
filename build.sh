#!/bin/bash 

SERVER=$1

if [ -z "$SERVER" ];
then
  echo "do nothing..."
else
  docker build -t builder .

  HASH=$(git rev-parse HEAD)
  VERSION=${HASH:0:8}

  if [ -z "$DOCKER_USERNAME" ];
  then
    echo "no login"
  else
    echo "login docker..."
    docker login --username "${DOCKER_USERNAME}" --password "${DOCKER_PASSWORD}" "$SERVER"
  fi;

  echo "Build bot ${VERSION}..."
  docker build -t "$SERVER/action:$VERSION" -f Dockerfile .
  docker push "$SERVER/action:$VERSION"
fi;