#!/bin/bash

su -c "/web/bin/redeploy.sh" www-data

# restart 
supervisorctl restart uwsgi

