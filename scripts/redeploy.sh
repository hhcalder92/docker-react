#!/bin/bash

su -c "{{DEPLOY_ROOT}}/bin/redeploy.sh" {{WEB_USER}}

# restart 
supervisorctl restart uwsgi

