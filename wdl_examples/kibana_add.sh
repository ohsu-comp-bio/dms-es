#!/bin/bash
# add wdl workflow to elastic search for downstream kibana display and cromwell submission
if [ "$#" != "3" ]; then
    echo "Illegal number of parameters"
    echo '$1 - wdl_workflow_name'
    echo '$2 - wdl_meta_param_name'
    echo '$3 - script file path'
    exit 1
fi

# add workflow to the kibana config passed to all controllers
curl -XPOST  $(docker-machine ip default):9200/.kibana/config/4.2.2-snapshot/_update -d "{
  \"doc\" : {
    \"cccWdlWorkflows\":{$1:{\"id\":\"$1\",\"meta_param_name\":\"$2\",\"wdl_base64_script_body\":\"$( base64 $3 )\"}}
   }
}"
