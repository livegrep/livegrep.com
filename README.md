This directory contains Google Cloud Platform / Google Kubernetes
Engine configuration for livegrep.com

# Directories

- `docker/` -- docker images
  - `base/` -- Base Docker image all images inherit from.
  - `backend/` -- Backend docker image (serves queries from a prebuilt
    index)
  - `frontend/` -- Frontend (http web server) docker image.
  - `indexer/` -- Indexer (creates a new index and uploads to google
    storage) docker image.
- `kubernetes/` -- Kubernetes configuration.

# Secrets

We require the following secrets in kubernets (currently configured by
hand):

- `gcp.cert-manager` -- `service-account.json` containing credentials
  for a servic eaccount with `roles/dns.admin`
- `gcp.livegrep-indexer` -- `service-account.json` containing
  credentials for a service account with rw to the livegrep bucket.
- `github.ssh` -- an `id_ed25519` containing an ssh key with github
  access to the indexed repositories.
- `github.oauth` -- an `oauth_key` key containing a github oauth key
  with public-access permissions.

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
