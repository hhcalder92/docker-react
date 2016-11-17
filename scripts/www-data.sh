#!/bin/bash
# import envirorment (virtualenv)
source /etc/bashrc      

export PATH=/usr/local/bin:$PATH
source /usr/local/bin/virtualenvwrapper.sh
echo 'export PATH=/usr/local/bin:$PATH ; source /usr/local/bin/virtualenvwrapper.sh' >>$HOME/.bash_profile 

echo $HOME 
echo $PROJECT
id
whoami 

if cd $DEPLOY_DIR ; then 
        mkvirtualenv $PROJECT
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

