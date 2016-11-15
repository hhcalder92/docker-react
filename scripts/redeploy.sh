#!/bin/bash
source /etc/bashrc

workon $PROJECT 

cd $DEPLOY_ROOT
git pull origin develop
pip install -r requirements.txt

python manage.py migrate 

sudo supervisorctl restart uwsgi

