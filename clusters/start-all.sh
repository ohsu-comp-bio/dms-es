elasticsearch   -Des.network.host=0.0.0.0 --path.conf=/portland/config  &
elasticsearch   -Des.network.host=0.0.0.0 --path.conf=/austin/config    &
elasticsearch   -Des.network.host=0.0.0.0 --path.conf=/boston/config    &



# # http://rogerwelin.github.io/kibana/elasticsearch/2015/03/06/kibana4-on-elasticsearch-tribe-node.html
# eval "export tribe_kibana_server=127.0.0.1:9201"
# curl -X PUT http://$tribe_kibana_server/.kibana/
# curl -H 'Accept: application/json' -X PUT -d '{"index-pattern":{"properties":{"title":{"type":"string"},"timeFieldName":{"type":"string"},"intervalName":{"type":"string"},"customFormats":{"type":"string"},"fields":{"type":"string"}}}}' $tribe_kibana_server/.kibana/_mapping/index-pattern
# curl -H 'Accept: application/json' -X PUT -d '{"search":{"properties":{"title":{"type":"string"},"description":{"type":"string"},"hits":{"type":"integer"},"columns":{"type":"string"},"sort":{"type":"string"},"version":{"type":"integer"},"kibanaSavedObjectMeta":{"properties":{"searchSourceJSON":{"type":"string"}}}}}}' $tribe_kibana_server/.kibana/_mapping/search
# curl -H 'Accept: application/json' -X PUT -d '{"dashboard":{"properties":{"title":{"type":"string"},"hits":{"type":"integer"},"description":{"type":"string"},"panelsJSON":{"type":"string"},"version":{"type":"integer"},"kibanaSavedObjectMeta":{"properties":{"searchSourceJSON":{"type":"string"}}}}}}' $tribe_kibana_server/.kibana/_mapping/dashboard
# curl -H 'Accept: application/json' -X PUT -d '{"visualization":{"properties":{"title":{"type":"string"},"visState":{"type":"string"},"description":{"type":"string"},"savedSearchId":{"type":"string"},"version":{"type":"integer"},"kibanaSavedObjectMeta":{"properties":{"searchSourceJSON":{"type":"string"}}}}}}' $tribe_kibana_server/.kibana/_mapping/visualization


# see https://github.com/elastic/elasticsearch/issues/14573
# elasticsearch --path.conf=/tribe/config
elasticsearch -Des.network.host=0.0.0.0  \
    -Des.cluster.name=ccc \
    -Des.node.name=tribe \
    -Des.tribe.t1.cluster.name=boston \
    -Des.tribe.t2.cluster.name=austin \
    -Des.tribe.t3.cluster.name=portland \
    -Des.logger.level=DEBUG
