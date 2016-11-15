#!/bin/bash

#run ass {{WEB_USER}}
su -c "{{DEPLOY_ROOT}}/bin/runtests.sh" {{WEB_USER}}

