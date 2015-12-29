# livegrep.com configuration

This repository contains the configuration used by the production
[livegrep.com][livegrep.com] deployment of
[livegrep][https://github.com/livegrep/livegrep].

The configuration is split into two pieces:

## ansible/

[Ansible][https://ansible.com/] configuration that configures the
individual instances. We use a
[single-playbook](http://nylas.com/blog/graduating-past-playbooks/)
pattern, with one role per instance type.

## terraform/

[Terraform][https://terraform.io] configuratio for managing the EC2
account that runs livegrep.com.
