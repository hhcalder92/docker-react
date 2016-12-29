#!/bin/bash

# import envirorment (virtualenv)
source /etc/bashrc


mkdir -p $HOME

cd $HOME

[[ ! -d $PROJECT_FRONTEND ]] && git clone http://docker@calderon.solutions/git/r/art/${PROJECT_FRONTEND}.git $PROJECT_FRONTEND

cd /web/$PROJECT_FRONTEND

gulp compile
