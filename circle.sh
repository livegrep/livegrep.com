#!/bin/bash
set -eu
docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
latest=
if [ "$CIRCLE_BRANCH" = "main" ]; then
    latest=--latest
fi
bin/build --push $latest
