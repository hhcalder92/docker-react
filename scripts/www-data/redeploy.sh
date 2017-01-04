#!/bin/bash

frontend()
{
	# Project Variables 
	source /etc/bashrc

	echo -e "\n#### FRONTEND ####"

	cd $APP_DIR
	git pull origin develop
	npm install
	gulp build
}

backend() 
{
	# Virtualenv
	export PATH=/usr/local/bin:$PATH
	source /usr/local/bin/virtualenvwrapper.sh

	# Project Variables 
	source /etc/bashrc

	echo -e "\n#### BACKEND ####"

	# Enter env
	workon $PROJECT 

	#redeploy 
	cd $DEPLOY_DIR

	git pull origin develop
	pip install -r requirements.txt

	# migrate 
	python manage.py migrate

	# collect static data 
	python manage.py collectstatic --noinput
}

case $1 in 
	frontend)
		frontend()
		;;
	backend)
		backend()
		;;
	*)
		backend()
		frontend()
		;;
esac
 
