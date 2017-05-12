#! /bin/sh

cd `dirname $0`
docker run -i -t -d --name test_docker_container centos:centos6.9 /bin/bash > /dev/null 2>&1
ansible-playbook -i ../playbooks/inventory ../playbooks/test.yml

rake spec