#!/bin/bash

export PROJECT=artmart-city
export DEPLOY_ROOT=/web
export DEPLOY_DIR=$DEPLOY_ROOT/$PROJECT
export WEB_USER=www-data
export UWSGI_APPS_ENABLED_DIR=/etc/uwsgi/apps-enabled

# Working dir 
[[ ! -d $DEPLOY_ROOT ]] && mkdir -p $DEPLOY_ROOT
[[ ! -d $UWSGI_APPS_ENABLED_DIR ]] && mkdir -p $UWSGI_APPS_ENABLED_DIR
cd $DEPLOY_ROOT 

# modify generic_supervisor.conf for project 
cp /tmp/generic_supervisor.conf 		$UWSGI_APPS_ENABLED_DIR/${PROJECT}.ini
sed -i -e "s/{{PROJECT}}/$PROJECT/g" 		$UWSGI_APPS_ENABLED_DIR/${PROJECT}.ini
sed -i -e "s#{{DEPLOY_DIR}}#${DEPLOY_DIR}#g" 	$UWSGI_APPS_ENABLED_DIR/${PROJECT}.ini
sed -i -e "s/{{WEB_USER}}/$WEB_USER/g" 		$UWSGI_APPS_ENABLED_DIR/${PROJECT}.ini


su - $PROJECT << block
# import envirorment (virtualenv)
source /etc/bashrc

[[ ! -d $PROJECT ]] && git clone http://docker@calderon.solutions/git/r/art/${PROJECT}.git $PROJECT
 
[[ ! -x workon ]] && mkvirtualenv $PROJECT
if  workon $PROJECT ; then 
	if cd $DEPLOY_DIR ; then 
		pwd					;
		sudo pip install -I pillow		;
                pip install psycopg2			;
                pip install pycurl 			;
		pip install -r requirements.txt 	;
	else 
		echo "virtualenv $PROJECT not found "	;
	fi
else
	echo "$PROJECT DNE"				;
fi
block 

