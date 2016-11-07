FROM ubuntu:16.04
#docker file 

RUN mkdir -p /etc/supervisor/conf.d

RUN apt-get update && apt-get install -y \
	git \
	python \
	python-dev \
	python-setuptools \
	python-django \
	supervisor \
	sqlite3 \
	python-psycopg2 \
	libmysqlclient-dev \
	libmemcached-dev \
	libpq-dev \
	libjpeg-dev \
	openssl \
	python-pip \
	libcurl4-openssl-dev \
	nodejs \
	npm \
	uwsgi 


RUN easy_install pip

RUN pip install virtualenv

RUN pip install virtualenvwrapper --upgrade --ignore-installed six

RUN npm install -g gulp

RUN mkdir -p /scripts

COPY scripts/ /scripts/
COPY etc/ /etc/

RUN /scripts/configure_backend.sh

RUN /scripts/configure_backend.sh
 
