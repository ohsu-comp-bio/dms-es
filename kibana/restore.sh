#!/bin/bash

#sudo apt-get install -y npm
#npm install elasticdump
#sudo ln -s /usr/bin/nodejs /usr/bin/node

elasticdump \
--input=kibana-export.json \
--output=$1 \
--type=data