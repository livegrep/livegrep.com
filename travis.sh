#!/bin/bash
set -eux
docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
latest=
if [ "$TRAVIS_BRANCH" = "master" ] && [ "$TRAVIS_PULL_REQUEST" = "false" ]; then
    latest=--latest
fi
bin/build --push $latest
