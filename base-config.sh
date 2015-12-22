#!/bin/sh
set -eux
adduser --system livegrep --home=/opt/livegrep
apt-get -y install python-virtualenv
sudo -Hu livegrep sh -eux <<'EOF'
virtualenv /opt/livegrep/venv
/opt/livegrep/venv/bin/pip install awscli
EOF

sudo -Hu livegrep sh -eux <<'EOF'
/opt/livegrep/venv/bin/aws s3 cp s3://livegrep/config/BUILD /opt/livegrep
build_id=$(cat /opt/livegrep/BUILD)
/opt/livegrep/venv/bin/aws s3 cp s3://livegrep/builds/livegrep-${build_id}.tgz /tmp/
mkdir /opt/livegrep/deploy
tar -C /opt/livegrep/deploy --strip-components=1 -xzf /tmp/livegrep-${build_id}.tgz
EOF
