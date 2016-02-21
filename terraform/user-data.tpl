#!/bin/bash
set -ex
event="$(/usr/local/bin/find-lifecycle-event livegrep-asg)"
abandon() {
    /usr/local/bin/complete-lifecycle-event "$event" ABANDON
}
trap abandon ERR

export PYTHONUNBUFFERED=1
echo 'localhost ansible_connection=local' > /etc/ansible/hosts
ansible-pull -e 'role=${role}' -e 'livegrep_bucket=${s3_bucket}' ${extra_args} -U https://github.com/livegrep/livegrep.com/ ansible/livegrep.yml
/usr/local/bin/complete-lifecycle-event "$event" CONTINUE
