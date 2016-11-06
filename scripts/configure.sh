#!/bin/bash

PROJECT=artmart-city

source /etc/bashrc

mkdir -p /web/$PROJECT

cd /web 

[[ ! -d $PROJECT ]] && git clone http://docker@calderon.solutions/git/r/art/artmart-city.git $PROJECT

[[ ! -x workon ]] && mkvirtualenv $PROJECT

if cd $PROJECT ; then 
	if  workon $PROJECT ; then 
		sudo pip install -I pillow
		pip install psycopg2
		pip install pycurl
		pip install -r requirements.txt
	else 
		echo "virtualenv $PROJECT not found "
	fi
else
	echo "$PROJECT DNE"
fi

