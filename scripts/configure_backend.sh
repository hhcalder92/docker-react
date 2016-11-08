#!/bin/bash

export PROJECT=artmart-city
export DEPLOY_ROOT=/web
export DEPLOY_DIR=$DEPLOY_ROOT/$PROJECT
export WEB_USER=www-data
export UWSGI_APPS_ENABLED_DIR=/etc/uwsgi/apps-enabled

# Working dir 
[[ ! -d $DEPLOY_DIR ]] && mkdir -p $DEPLOY_DIR
[[ ! -d $UWSGI_APPS_ENABLED_DIR ]] && mkdir -p $UWSGI_APPS_ENABLED_DIR

# modify generic_supervisor.conf for project 
cp /tmp/generic_supervisor.conf 		$UWSGI_APPS_ENABLED_DIR/${PROJECT}.ini
sed -i -e "s/{{PROJECT}}/$PROJECT/g" 		$UWSGI_APPS_ENABLED_DIR/${PROJECT}.ini
sed -i -e "s#{{DEPLOY_DIR}}#${DEPLOY_DIR}#g" 	$UWSGI_APPS_ENABLED_DIR/${PROJECT}.ini
sed -i -e "s/{{WEB_USER}}/$WEB_USER/g" 		$UWSGI_APPS_ENABLED_DIR/${PROJECT}.ini

# import envirorment (virtualenv)
source /etc/bashrc 	

workon $PROJECT || mkvirtualenv $PROJECT 
if  workon $PROJECT ; then 
	if cd $DEPLOY_DIR ; then 
		git status ||  git clone http://docker@calderon.solutions/git/r/art/${PROJECT}.git . 
		pip install -I pillow		
                pip install psycopg2			
                pip install pycurl 			
		pip install -r requirements.txt 	
	else 
		echo "virtualenv $PROJECT not found "	
	fi
else
	echo "$PROJECT DNE"				
fi

id
