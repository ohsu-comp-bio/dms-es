# add wdl workflow to elastic search for downstream kibana display and cromwell submission
# $1 - wdl_workflow_name
# $2 - wdl_meta_param_name
# $2 - wdl_base64_script_body
curl -XPUT $(docker-machine ip default):9200/api/ccc/wdl/$1 -d '{"id":"$1","meta_param_name":"$2","wdl_base64_script_body":"$( base64 $3 )"}'
