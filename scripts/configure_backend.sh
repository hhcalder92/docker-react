#!/bin/bash

# Enviroment Varibles
export PROJECT=artmart-city
export DEPLOY_ROOT=/web
export DEPLOY_DIR=$DEPLOY_ROOT/$PROJECT
export WEB_USER=www-data
export UWSGI_APPS_ENABLED_DIR=/etc/uwsgi/apps-enabled
export UWSGI_APPS_AVAIL_DIR=/etc/uwsgi/apps-available
export UWSGI_RUN_DIR=/run/uwsgi/app/$PROJECT
export UWSGI_CONF_DIR=/etc/supervisor/conf.d
export UWSGI_SOCKET_PATH=127.0.0.1:8000
export UWSGI_WORKER=1
export UWSGI_MAX_REQUESTS=5000
export UWSGI_BUFFER_SIZE=8192

# Working dir creation
[[ ! -d $DEPLOY_DIR ]] && mkdir -p $DEPLOY_DIR
[[ ! -d $UWSGI_APPS_ENABLED_DIR ]] && mkdir -p $UWSGI_APPS_ENABLED_DIR
[[ ! -s $UWSGI_APPS_AVAIL_DIR ]] && ln -s $UWSGI_APPS_ENABLED_DIR $UWSGI_APPS_AVAIL_DIR

# modify generic_supervisor.conf for uwsgi 
cp /tmp/generic_supervisor.conf 		$UWSGI_APPS_ENABLED_DIR/${PROJECT}.ini
sed -i -e "s/{{PROJECT}}/$PROJECT/g" 		$UWSGI_APPS_ENABLED_DIR/${PROJECT}.ini
sed -i -e "s#{{DEPLOY_DIR}}#${DEPLOY_DIR}#g" 	$UWSGI_APPS_ENABLED_DIR/${PROJECT}.ini
sed -i -e "s/{{WEB_USER}}/$WEB_USER/g" 		$UWSGI_APPS_ENABLED_DIR/${PROJECT}.ini

mkdir -p $UWSGI_RUN_DIR
chown ${WEB_USER}:${WEB_USER} $UWSGI_RUN_DIR

# modify generic_supervisor.conf for uwsgi 
cp /tmp/uwsgi_app.conf 		                		$UWSGI_CONF_DIR/${PROJECT}.ini
sed -i -e "s/{{PROJECT}}/$PROJECT/g"            		$UWSGI_CONF_DIR/${PROJECT}.ini
sed -i -e "s#{{DEPLOY_DIR}}#${DEPLOY_DIR}#g"    		$UWSGI_CONF_DIR/${PROJECT}.ini
sed -i -e "s/{{WEB_USER}}/$WEB_USER/g"          		$UWSGI_CONF_DIR/${PROJECT}.ini
sed -i -e "s/{{UWSGI_MAX_REQUESTS}}/$UWSGI_MAX_REQUESTS/g"      $UWSGI_CONF_DIR/${PROJECT}.ini
sed -i -e "s/{{UWSGI_BUFFER_SIZE}}/$UWSGI_BUFFER_SIZE/g"        $UWSGI_CONF_DIR/${PROJECT}.ini
sed -i -e "s/{{UWSGI_WORKERS}}/$UWSGI_WORKERS/g"	        $UWSGI_CONF_DIR/${PROJECT}.ini
sed -i -e "s#{{UWSGI_RUN_DIR}}#${UWSGI_RUN_DIR}#g"    		$UWSGI_CONF_DIR/${PROJECT}.ini
sed -i -e "s#{{UWSGI_SOCKET_PATH}}#${UWSGI_SOCKET_PATH}#g"      $UWSGI_CONF_DIR/${PROJECT}.ini

# import envirorment (virtualenv)
source /etc/bashrc 	

if cd $DEPLOY_DIR ; then 
	mkvirtualenv $PROJECT
	git status ||  git clone http://docker@calderon.solutions/git/r/art/${PROJECT}.git . 
	pip install -I pillow		
       	pip install psycopg2			
       	pip install pycurl 			
	pip install -r requirements.txt 	
else 
	echo "virtualenv $PROJECT not found "	
fi

#uwsgi --ini /etc/supervisor/conf.d/artmart-city.ini 
