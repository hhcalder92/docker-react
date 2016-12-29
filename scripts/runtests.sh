#!/bin/bash

service rabbitmq-server start
service memcached start

#run ass www-data
su -c "/web/bin/runtests.sh" www-data

