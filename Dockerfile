FROM ubuntu:16.04
#docker file 

RUN mkdir -p /etc/supervisor/conf.d /scripts 

# Deps 
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
	sudo \
	codeblocks \
	uwsgi 

USER www-data
WORKDIR /web

RUN easy_install pip
RUN pip install --upgrade pip
RUN pip install -I pillow
RUN pip install virtualenv psycopg2 pycurl
RUN pip install virtualenvwrapper --upgrade --ignore-installed six
RUN npm install -g gulp

# Copy Resources 
COPY common /tmp/
COPY scripts/ /scripts/
COPY etc/ /etc/

# Add users to container
#RUN useradd -ms /bin/bash artmart-city
#RUN useradd -ms /bin/bash artmart-city-frontend

RUN /scripts/configure_backend.sh
RUN /scripts/configure_frontend.sh

 
