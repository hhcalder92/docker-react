#!/bin/bash
# import envirorment (virtualenv)
source /etc/bashrc      

export PATH=/usr/local/bin:$PATH
source /usr/local/bin/virtualenvwrapper.sh
echo 'export PATH=/usr/local/bin:$PATH ; source /usr/local/bin/virtualenvwrapper.sh' >>$HOME/.bash_profile 

echo $HOME 
echo $PROJECT

# private key premissions 
[[ -f $DEPLOY_ROOT/.ssh/id_rsa ]] && chown 600 $DEPLOY_ROOT/.ssh/id_rsa

mkdir -p $APP_DIR 
if cd $APP_DIR ; then 
        git config --global user.name jenkins
        git config --global user.email jenkins@artmart.city
        git clone http://docker@calderon.solutions/git/r/art/${PROJECT_FRONTEND}.git .
        sudo npm install -g gulp 
#	npm install --save-dev gulp-babel babel-preset-es2015
	npm install
	gulp build 
fi

mkdir -p $MEDIA_DIR $STATIC_DIR

if cd $DEPLOY_DIR ; then 
        mkvirtualenv $PROJECT
	git config --global user.name jenkins
	git config --global user.email jenkins@artmart.city
        git status ||  git clone $BACKEND_REPO . 
        sudo pip install -I pillow           
        pip install psycopg2                    
        pip install pycurl                      
        pip install -r requirements.txt         


        if [[ -d .git ]] ; then
                cp /tmp/hooks                                   $DEPLOY_DIR/.git/hooks/pre-commit
                [[ ! -x $DEPLOY_DIR/.git/hooks/pre-commit ]] && chmod 755 $DEPLOY_DIR/.git/hooks/pre-commit
        fi

        [[ -f $DEPLOY_DIR/django_settings/local_settings.py ]] && rm $DEPLOY_DIR/django_settings/local_settings.py
        ln -s $DEPLOY_DIR/django_settings/local_settings.py.staging $DEPLOY_DIR/django_settings/local_settings.py
else 
        echo "cd $DEPLOY_DIR failed"
        exit
fi

