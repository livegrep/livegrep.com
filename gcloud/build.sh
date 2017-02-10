#!/bin/bash
set -eux

imgs=(base backend frontend indexer)
push=
build=1

TEMP=$(getopt -o '' --long push,build,no-build \
     -n 'build.sh' -- "$@")

if [ $? != 0 ] ; then exit 1 ; fi

eval set -- "$TEMP"
while true ; do
    case "$1" in
        --push) push=1; shift ;;
        --build) build=1; shift ;;
        --no-build) build=; shift ;;
        --) shift; break ;;
    esac
done

if [ "$#" -ne 0 ]; then
    imgs=("$@")
fi

if [ "$build" ]; then
    for img in "${imgs[@]}"; do
        docker build -t "livegrep-$img" "$img"
    done
fi

if [ "$push" ]; then
    for img in "${imgs[@]}"; do
        docker tag "livegrep-$img" "us.gcr.io/livegrep/$img"
        gcloud docker -- push "us.gcr.io/livegrep/$img"
    done
fi
