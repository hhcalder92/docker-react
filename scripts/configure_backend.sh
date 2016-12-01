#!/bin/bash

# import envirorment (virtualenv)
source /etc/bashrc    

# Working dir creation
[[ ! -d $DEPLOY_DIR ]] && mkdir -p $DEPLOY_DIR
[[ ! -d $UWSGI_APPS_ENABLED_DIR ]] && mkdir -p $UWSGI_APPS_ENABLED_DIR
[[ ! -s $UWSGI_APPS_AVAIL_DIR ]] && ln -s $UWSGI_APPS_ENABLED_DIR $UWSGI_APPS_AVAIL_DIR

# Directory for pid
mkdir -p $UWSGI_RUN_DIR
chown ${WEB_USER}:${WEB_USER} $UWSGI_RUN_DIR

# modify generic_supervisor.conf for uwsgi 
cp /tmp/generic_supervisor.conf 				$SUPERVISOR_CONF_DIR/${PROJECT}.conf
sed -i -e "s/{{PROJECT}}/$PROJECT/g" 				$SUPERVISOR_CONF_DIR/${PROJECT}.conf
sed -i -e "s#{{DEPLOY_DIR}}#${DEPLOY_DIR}#g" 			$SUPERVISOR_CONF_DIR/${PROJECT}.conf
sed -i -e "s/{{WEB_USER}}/$WEB_USER/g" 				$SUPERVISOR_CONF_DIR/${PROJECT}.conf

# modify generic_supervisor.conf for uwsgi 
cp /tmp/uwsgi_app.conf 		                		$UWSGI_APPS_ENABLED_DIR/${PROJECT}.ini
sed -i -e "s/{{PROJECT}}/$PROJECT/g"            		$UWSGI_APPS_ENABLED_DIR/${PROJECT}.ini
sed -i -e "s#{{DEPLOY_DIR}}#${DEPLOY_DIR}#g"    		$UWSGI_APPS_ENABLED_DIR/${PROJECT}.ini
sed -i -e "s/{{WEB_USER}}/$WEB_USER/g"          		$UWSGI_APPS_ENABLED_DIR/${PROJECT}.ini
sed -i -e "s/{{UWSGI_MAX_REQUESTS}}/$UWSGI_MAX_REQUESTS/g"      $UWSGI_APPS_ENABLED_DIR/${PROJECT}.ini
sed -i -e "s/{{UWSGI_BUFFER_SIZE}}/$UWSGI_BUFFER_SIZE/g"        $UWSGI_APPS_ENABLED_DIR/${PROJECT}.ini
sed -i -e "s/{{UWSGI_WORKERS}}/$UWSGI_WORKERS/g"	        $UWSGI_APPS_ENABLED_DIR/${PROJECT}.ini
sed -i -e "s#{{UWSGI_RUN_DIR}}#${UWSGI_RUN_DIR}#g"    		$UWSGI_APPS_ENABLED_DIR/${PROJECT}.ini
sed -i -e "s#{{UWSGI_SOCKET_PATH}}#${UWSGI_SOCKET_PATH}#g"      $UWSGI_APPS_ENABLED_DIR/${PROJECT}.ini

sed -i -e "s/{{WEB_USER}}/$WEB_USER/g"				/scripts/redeploy.sh
sed -i -e "s#{{DEPLOY_ROOT}}#${DEPLOY_ROOT}#g"                  /scripts/redeploy.sh


sed -i -e "s/{{WEB_USER}}/$WEB_USER/g"                          /scripts/runtests.sh
sed -i -e "s#{{DEPLOY_ROOT}}#${DEPLOY_ROOT}#g"                  /scripts/runtests.sh


[[ -d $DEPLOY_ROOT/bin ]] || mkdir -p $DEPLOY_ROOT/bin

# move redeploy script 
[[ -x /scripts/${WEB_USER}_redeploy.sh ]] && mv /scripts/${WEB_USER}_redeploy.sh $DEPLOY_ROOT/bin/redeploy.sh 

# move runtests script 
[[ -x /scripts/${WEB_USER}_runtests.sh ]] && mv /scripts/${WEB_USER}_runtests.sh $DEPLOY_ROOT/bin/runtests.sh

# www-data permissions  
chown www-data:www-data -R $DEPLOY_ROOT

# private key premissions 
[[ -f $DEPLOY_ROOT/.ssh/id_rsa ]] && chown 600 $DEPLOY_ROOT/.ssh/id_rsa

# www-data $HOME
usermod -d $DEPLOY_ROOT -s /bin/bash www-data 

# www-data script 
su -s /bin/bash -c /scripts/www-data.sh www-data  

