#!/bin/bash
set -eu
cd $(dirname "$0")

new_sha=
new_revision=
bump=
do_update=

dry_run=
TEMP=$(getopt -o bn --long sha:,revision:,bump,dry-run \
              -n 'update-version.sh' -- "$@")

if [ $? != 0 ] ; then exit 1 ; fi

eval set -- "$TEMP"
while true ; do
    case "$1" in
        --sha) new_sha=$2; do_update=1; shift 2 ;;
        --revision) new_revision=$2; do_update=1; shift 2 ;;
        --bump|-b) bump=1; do_update=1; shift ;;
        --dry-run|-n) dry_run=1; shift ;;
        --) shift; break ;;
        *) echo "internal error: $1" >&2; exit 1 ;;
    esac
done

version=${1:-$(cat VERSION)}

if [ "$do_update" ]; then
    sha=${version%-*}
    revision=${version#*-}
    if [ "$new_sha" ]; then
        sha=$new_sha
        revision=0
    fi
    if [ "$new_revision" ]; then
        revision=$new_revision
    fi
    if [ "$bump" ]; then
        let revision=revision+1
    fi
    version="$sha-$revision"
fi

echo "Setting version: $version"

if [ "$dry_run" ]; then
    exit 0
fi

echo "$version" > VERSION

new_version=$version perl -i -lape '
 s{image: us.gcr.io/livegrep/[a-zA-Z0-9_-]+:\K(\S+)}{$ENV{new_version}}
' kubernetes/*.yaml
