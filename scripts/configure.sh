#!/bin/bash

# install nod e
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
apt-get update 
apt-get install nodejs

# import envirorment (virtualenv)
source /etc/bashrc    

# www-data sudo permission 
echo "www-data ALL=(ALL) NOPASSWD: ALL"  >> /etc/sudoers

# Working dir creation
[[ ! -d $DEPLOY_DIR ]] && mkdir -p $DEPLOY_DIR
[[ ! -d $UWSGI_APPS_ENABLED_DIR ]] && mkdir -p $UWSGI_APPS_ENABLED_DIR
[[ ! -s $UWSGI_APPS_AVAIL_DIR ]] && ln -s $UWSGI_APPS_ENABLED_DIR $UWSGI_APPS_AVAIL_DIR

# Directory for pid
mkdir -p $UWSGI_RUN_DIR
chown ${WEB_USER}:${WEB_USER} $UWSGI_RUN_DIR

# save original nginx config
[[ -f /etc/nginx/conf.d/default.conf ]] && mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.1

# nginx config 
mkdir -p /etc/nginx/{sites-available,sites-enabled}

# modify nginx template  
if [[ -f /etc/nginx/sites-available/default ]]; then 
	sed -i -e "s/{{domain}}/$DOMAIN/g"                      /etc/nginx/sites-available/default
	sed -i -e "s#{{backend_directory}}#$BACKEND_DIR#g"      /etc/nginx/sites-available/default
	sed -i -e "s#{{static_directory}}#$STATIC_DIR#g"        /etc/nginx/sites-available/default
	sed -i -e "s#{{media_directory}}#$MEDIA_DIR#g"          /etc/nginx/sites-available/default
	sed -i -e "s#{{web_app_directory}}#$APP_DIR#g"  	/etc/nginx/sites-available/default
#        sed -i -e "s#{{web_app_directory}}#$WEB_APP_DIR#g"      /etc/nginx/sites-available/default
	# move and link 
	mv /etc/nginx/sites-available/default /etc/nginx/sites-available/$PROJECT
	ln -s /etc/nginx/sites-available/$PROJECT /etc/nginx/sites-enabled/$PROJECT
fi

# modify generic_supervisor.conf for uwsgiSUPERVISOR_CONF_DIR 
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
[[ -x /scripts/${WEB_USER}/redeploy.sh ]] && cp /scripts/${WEB_USER}/redeploy.sh $DEPLOY_ROOT/bin/redeploy.sh 

# move runtests script 
[[ -x /scripts/${WEB_USER}/test.sh ]] && cp /scripts/${WEB_USER}/test.sh $DEPLOY_ROOT/bin/test.sh

# www-data permissions  
chown www-data:www-data -R $DEPLOY_ROOT

# private key premissions 
[[ -f $DEPLOY_ROOT/.ssh/id_rsa ]] && chmod 600 $DEPLOY_ROOT/.ssh/id_rsa

# www-data $HOME
usermod -d $DEPLOY_ROOT -s /bin/bash www-data 

# www-data script 
su -s /bin/bash -c /scripts/www-data.sh www-data  

