#!/bin/sh
export PYTHONUNBUFFERED=1
echo 'localhost ansible_connection=local' > /etc/ansible/hosts
ansible-pull -e 'role=${role}' -e 'livegrep_bucket=${s3_bucket}' ${extra_args} -U https://github.com/livegrep/livegrep.com/ ansible/livegrep.yml
