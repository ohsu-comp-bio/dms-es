#!/bin/bash

#sudo apt-get install -y npm
#npm install elasticdump
#sudo ln -s /usr/bin/nodejs /usr/bin/node

elasticdump \
--input=$1 \
--output=kibana-export.json \
--type=data \
--searchBody='{"filter": { "or": [ {"type": {"value": "search"}}, {"type": {"value": "dashboard"}}, {"type" : {"value":"visualization"}}] }}'