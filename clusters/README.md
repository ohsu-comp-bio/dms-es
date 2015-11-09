


# start a docker image that supports elastic search
```
docker run -it --rm \
      -p 9200:9200 -p 9300:9300 \
      -p 9201:9201 -p 9301:9301 \
      -p 9202:9202 -p 9302:9302 \
      -p 9203:9203 -p 9303:9303 \
      -v $(pwd)/clusters:/data \
      -t elasticsearch:ccc  \
      bash
```


# start 4 instances of ES, 1 tribe node & 3 clusters
```
elasticsearch -Des.config=/data/tribe/config/elasticsearch.yml > /data/tribe/log.log &
elasticsearch -Des.config=/data/portland/config/elasticsearch.yml  > /data/portland/log.log &
elasticsearch -Des.config=/data/austin/config/elasticsearch.yml  > /data/austin/log.log &
elasticsearch -Des.config=/data/boston/config/elasticsearch.yml  > /data/boston/log.log &
```
-u elasticsearch \

docker run -it --rm \
      --privileged=true \
      -p 9200:9200 -p 9300:9300 \
      -p 9201:9201 -p 9301:9301 \
      -p 9202:9202 -p 9302:9302 \
      -p 9203:9203 -p 9303:9303 \
      -v $(pwd)/clusters:/data:Z \
      -t elasticsearch:latest  \
      bash

docker pull elasticsearch

docker run \
  -v $(pwd)/clusters/tribe/config:/usr/share/elasticsearch/config:ro \
  -v $(pwd)/clusters/tribe/data:/usr/share/elasticsearch/data:rw \
  -p 9200:9200 -p 9300:9300 \
  -t elasticsearch:latest  \
  elasticsearch


docker run --name tribe  -d  --privileged=true -v $(pwd)/clusters/tribe/config:/usr/share/elasticsearch/config:ro -p 9200:9200 -p 9300:9300   -t elasticsearch:latest    elasticsearch --network.host=0.0.0.0

docker run --name portland -d   --privileged=true -v $(pwd)/clusters/portland/config:/usr/share/elasticsearch/config:ro       -p 9201:9201 -p 9301:9301   -t elasticsearch:latest    elasticsearch --network.host=0.0.0.0

docker run --name austin  -d   --privileged=true -v $(pwd)/clusters/austin/config:/usr/share/elasticsearch/config:ro       -p 9202:9202 -p 9302:9302   -t elasticsearch:latest    elasticsearch --network.host=0.0.0.0

docker run --name boston  -d   --privileged=true -v $(pwd)/clusters/boston/config:/usr/share/elasticsearch/config:ro       -p 9203:9203 -p 9303:9303   -t elasticsearch:latest    elasticsearch --network.host=0.0.0.0



## logstash

* from logstash dir
docker run  -v $(pwd):/data -it  logstash  logstash  -f ./data/icgc-*.conf  -v --verbose  --debug rspecUsing Accessor#strict_set for specs

 curl -XDELETE 'http://192.168.99.100:9201/*-icgc/'




kibana setup

```
# http://rogerwelin.github.io/kibana/elasticsearch/2015/03/06/kibana4-on-elasticsearch-tribe-node.html
eval "export tribe_kibana_server=$(docker-machine ip default):9201"
curl -X PUT http://$tribe_kibana_server/.kibana/

curl -H 'Accept: application/json' -X PUT -d '{"index-pattern":{"properties":{"title":{"type":"string"},"timeFieldName":{"type":"string"},"intervalName":{"type":"string"},"customFormats":{"type":"string"},"fields":{"type":"string"}}}}' $tribe_kibana_server/.kibana/_mapping/index-pattern
curl -H 'Accept: application/json' -X PUT -d '{"search":{"properties":{"title":{"type":"string"},"description":{"type":"string"},"hits":{"type":"integer"},"columns":{"type":"string"},"sort":{"type":"string"},"version":{"type":"integer"},"kibanaSavedObjectMeta":{"properties":{"searchSourceJSON":{"type":"string"}}}}}}' $tribe_kibana_server/.kibana/_mapping/search
curl -H 'Accept: application/json' -X PUT -d '{"dashboard":{"properties":{"title":{"type":"string"},"hits":{"type":"integer"},"description":{"type":"string"},"panelsJSON":{"type":"string"},"version":{"type":"integer"},"kibanaSavedObjectMeta":{"properties":{"searchSourceJSON":{"type":"string"}}}}}}' $tribe_kibana_server/.kibana/_mapping/dashboard
curl -H 'Accept: application/json' -X PUT -d '{"visualization":{"properties":{"title":{"type":"string"},"visState":{"type":"string"},"description":{"type":"string"},"savedSearchId":{"type":"string"},"version":{"type":"integer"},"kibanaSavedObjectMeta":{"properties":{"searchSourceJSON":{"type":"string"}}}}}}' $tribe_kibana_server/.kibana/_mapping/visualization
```

# kibana startup
```
eval "export elastic_search_server=$(docker-machine ip default):9200"
docker run -e ELASTICSEARCH_URL=http://$elastic_search_server -p 5601:5601  -d  kibana
```


##### _misc …_

https://github.com/mobz/elasticsearch-head

http://www.elasticui.com/

https://github.com/rdpatil4/ESClient

http://www.elastichq.org/features.html

https://github.com/torkelo/grafana

http://www.visualcinnamon.com/2015/07/voronoi.html

https://github.com/OlegKunitsyn/elasticsearch-browser


```

# query the tribe
curl 'localhost:9200/_mget' -d '{ "docs" : [ { "_index" : "metadata1","_id" : "1" } , { "_index" : "metadata2","_id" : "1" },  { "_index" : "metadata3","_id" : "1" } ] } '


curl -XGET 'http://localhost:9200/metadata*/meta/_search?_id=1' -d '{
    "user" : "kimchy",
    "postDate" : "2009-11-15T14:12:12",
    "message" : "trying out Elasticsearch"
}
'



CMDI-UK-SP16734
curl -XGET 'http://localhost:9200/icgc/speci/_search?_id=12-00127

curl -XGET 'http://localhost:9200/metadata*/meta/_search?_id=12-00127


ps -ef | grep elastic | awk '{print "kill -9 ", $2 }'
```
