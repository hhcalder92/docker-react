FROM ubuntu:16.04
#docker file 


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
	libcurl4-openssl-dev
	sudo \
	vi


RUN easy_install pip

RUN pip install virtualenv

RUN pip install virtualenvwrapper --upgrade --ignore-installed six

#USER www-data
#WORKDIR /var/www

CMD mkdir -p /scripts

COPY scripts/ /scripts/
COPY etc/ /etc/

CMD /scripts/configure.sh 
