#!/bin/bash

curl -XDELETE 'elasticsearch:9200/individual-ohsu/'
curl -XDELETE 'elasticsearch:9200/specimen-ohsu/'
curl -XDELETE 'elasticsearch:9200/dataset-ohsu/'
