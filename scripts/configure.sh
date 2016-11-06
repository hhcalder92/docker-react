#!/bin/bash

PROJECT=artmart-city

mkdir -p /web/$PROJECT

cd /web 

git clone http://docker@calderon.solutions/git/r/art/artmart-city.git $PROJECT

[[ ! -x workon ]] && /scripts/setupenv.sh 

if [[ workon $PROJECT ]] ; then 
	sudo pip install -I pillow
	pip install psycopg2
	pip install pycurl
	pip install -r requirements.txt
else 
	echo "virtualenv $PROJECT not found "
fi
