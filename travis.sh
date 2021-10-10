#!/bin/bash
docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
set -eux
latest=
if [ "$TRAVIS_BRANCH" = "main" ] && [ "$TRAVIS_PULL_REQUEST" = "false" ]; then
    latest=--latest
fi
bin/build --push $latest
