#!/bin/sh
set -eux
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get install -y python-software-properties git
sudo add-apt-repository -y ppa:ansible/ansible
sudo apt-get update
sudo apt-get install -y ansible
echo 'localhost ansible_connection=local' > /etc/ansible/hosts
ansible-pull -e 'role=${role}' -e 'livegrep_bucket=${s3_bucket}' ${extra_args} -U https://github.com/livegrep/livegrep.com/ ansible/livegrep.yml
