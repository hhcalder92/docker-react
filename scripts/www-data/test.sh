#!/bin/bash

BRANCH=${1:-develop}

# Virtualenv
export PATH=/usr/local/bin:$PATH
source /usr/local/bin/virtualenvwrapper.sh

# Project Variables 
source /etc/bashrc

# Enter env
workon $PROJECT 

#redeploy 
cd $DEPLOY_DIR
git pull origin $BRANCH
pip install -r requirements.txt

# test 
python manage.py test --settings django_settings.test_settings

#coverage 
coverage run manage.py test --settings django_settings.test_settings && coverage report
