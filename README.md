This directory contains docker configuration for livegrep.com

# Directories

- `docker/` -- docker images
  - `base/` -- Base Docker image all images inherit from.
    - `indexer/` -- Indexer docker image (contains `git` and some other dependencies).
- `compose/` -- `docker-compose` configuration.

# Scripts

- `bin/build` builds docker images. It parses the `VERSION` file,
  which is of the form `SHA1-REVISION`, where `sha1` is the
  10-character sha1-prefix version of the `livegrep` repository, and
  `REVISION` is a version number of updates in this repository within
  a given release.
- `bin/update-version` updates the `VERSION` file and also the version
  configuration in the kubernetes configuration. It is most commonly
  run with `-b` to bump the `REVISION`, or `--sha` to change the `SHA`
  field. If run with no arguments, it synchronizes `kubernetes/*.yaml`
  with `VERSION`.
