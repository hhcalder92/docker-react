#!/bin/bash

# Virtualenv
export PATH=/usr/local/bin:$PATH
source /usr/local/bin/virtualenvwrapper.sh

# Project Variables 
source /etc/bashrc

# Enter env
workon $PROJECT 

#redeploy 
cd $DEPLOY_DIR

git config --local user.name jenkins 
git config --local user.email jenkins@artmart.city

git pull origin develop
pip install -r requirements.txt

# migrate 
python manage.py migrate 

