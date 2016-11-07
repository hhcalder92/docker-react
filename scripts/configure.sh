#!/bin/bash

PROJECT=artmart-city

source /etc/bashrc

mkdir -p /web

cd /web 

[[ ! -d $PROJECT ]] && git clone http://docker@calderon.solutions/git/r/art/artmart-city.git $PROJECT

[[ ! -x workon ]] && mkvirtualenv $PROJECT

if  workon $PROJECT ; then 
	if cd /web/$PROJECT ; then 
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

