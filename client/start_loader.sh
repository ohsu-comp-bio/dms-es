eval "export elastic_search_servers=$(docker-machine ip default):9201,$(docker-machine ip default):9202,$(docker-machine ip default):9203"
docker run -i -v ..:/home -e "elastic_search_servers=$elastic_search_servers"    -t  es-client  bash
