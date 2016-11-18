#!/bin/bash

service rabbitmq-server start
service memcached start

#run ass {{WEB_USER}}
su -c "{{DEPLOY_ROOT}}/bin/runtests.sh" {{WEB_USER}}

