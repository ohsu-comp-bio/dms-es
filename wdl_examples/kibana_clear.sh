#!/bin/bash
# remove all jobs from kibana's configuration by setting default config
curl -XPUT  $(docker-machine ip default):9200/.kibana/config/4.2.2-snapshot -d '{
  "buildNum":8467,
  "defaultIndex":"aggregated-resource",
  "cccWdlURL":"/api/workflows/v1"
}'
