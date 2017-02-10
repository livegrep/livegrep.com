This directory contains Google Cloud Platform / Google Kubernetes
Engine configuration.

# Directories

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
