#!/bin/bash

PROJECT=artmart-city-frontend

mkdir -p /web

cd /web

[[ ! -d $PROJECT ]] && git clone http://docker@calderon.solutions/git/r/art/${PROJECT}.git $PROJECT

cd /web/$PROJECT

gulp compile
