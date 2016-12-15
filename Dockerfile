FROM ubuntu:16.04
#docker file 

COPY sshkeys /web/.ssh

# Create user
#RUN groupadd -r www-data
RUN grep www-data /etc/passwd  || useradd -r -g www-data www-data
#RUN sudo chown -R www-data /web /scripts /tmp

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
	memcached \
	libcurl4-openssl-dev \
	rabbitmq-server \
	nodejs \
	npm \
	sudo \
	nano \
	flake8 \
	codeblocks \
	uwsgi-core  \
	uwsgi-plugin-python \
	nginx

#RUN service rabbitmq-server start
#RUN service memcached start

RUN easy_install pip
RUN pip install --upgrade pip
RUN pip install -I pillow
RUN pip install virtualenv psycopg2 pycurl coverage
RUN pip install virtualenvwrapper --upgrade --ignore-installed six
#RUN npm install -g gulp

# Copy Resources 
COPY common/ /tmp/
COPY scripts/ /scripts/
COPY etc/ /etc/

RUN /scripts/configure_backend.sh

#RUN chmod 755 -R /web 
#RUN chown www-data -R /web

EXPOSE 8000

#CMD ["supervisord",  "-c" ,"/etc/supervisor/conf.d/artmart-city.ini"]
CMD ["supervisord","--nodaemon","-c","/etc/supervisor/supervisord.conf"] 

