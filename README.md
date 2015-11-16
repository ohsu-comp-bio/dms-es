#Metadata - Elastic Search
---
###  Scope

#### Epics

```
As a Researcher , I need to find data across my institution and my partners.
As a Researcher, I need to analyze those query results in a time efficient manner.

```

#### Stories

```
As a CCC engineer, in order to confirm our understanding of user spreadsheets and directories, I need a working, demonstrable POC that reads the data and publishes same to a data store.  

As a CCC engineer, in order to confirm our understanding of the data model, I need data loaded into elastic search.  

As a CCC engineer, in order to confirm our understanding of the user interactions, I need kibana connected to the datasource.  

```

**For more,see:**
 https://ohsu.box.com/shared/static/luh1wsefp60uf92wd7w3c27e470behy2.pptx

### Overview

![image](https://cloud.githubusercontent.com/assets/47808/11165796/e41bcd7e-8ace-11e5-826f-5808d13bc79a.png)


---

Run the latest version of the ELK (Elasticseach, Logstash, Kibana) stack with Docker and Docker-compose.

It will give you the ability to analyze any data set by using the searching/aggregation capabilities of Elasticseach and the visualization power of Kibana.

Based on the official images:

* [elasticsearch](https://registry.hub.docker.com/_/elasticsearch/)
* [logstash](https://registry.hub.docker.com/_/logstash/)
* [kibana](https://registry.hub.docker.com/_/kibana/)

# Requirements

## Setup

1. Install [Docker](http://docker.io).
2. Install [Docker-compose](http://docs.docker.com/compose/install/).
3. Clone this repository

## Startup

### docker



```
# start elasticsearch and kibana
$ docker-compose up
Starting dmses_elasticsearch_1
Starting dmses_kibana_1
...

# verified it started

$ docker-compose ps
        Name                       Command               State                Ports
-------------------------------------------------------------------------------------------------
dmses_elasticsearch_1   /docker-entrypoint.sh elas ...   Up      0.0.0.0:9200->9200/tcp, 9300/tcp
dmses_kibana_1          /docker-entrypoint.sh kibana     Up      0.0.0.0:5601->5601/tcp

```

### cluster state

```
# show cluster state
$ curl $(docker-machine ip default):9200/_cluster/state/nodes?pretty
{
  "cluster_name" : "ccc-es",
  "nodes" : {
    "oWFWGdDWQlucmyAX-mEtGw" : {
      "name" : "central",
      "transport_address" : "172.17.0.2:9300",
      "attributes" : { }
    }
  }
}
```

### show index list
```
$curl $(docker-machine ip default):9200/_cat/indices?v
health status index           pri rep docs.count docs.deleted store.size pri.store.size
yellow open   .kibana           1   1          1            0      2.9kb          2.9kb
yellow open   sample-icgc       5   1        850            0    984.7kb        984.7kb
yellow open   specimen-icgc     5   1        658            0        1mb            1mb
yellow open   individual-icgc   5   1        309            0    516.4kb        516.4kb
...
```

### delete an index
```
curl -XDELETE dev:9200/sample-baml
```


### ui

http://$(docker-machine ip default):5601/status

![image](https://cloud.githubusercontent.com/assets/47808/11165839/afe4bf82-8ad0-11e5-9f6a-102e367c7fb2.png)

### load data

```
$ cd logstash/icgc
$ docker run  --add-host elasticsearch:$(docker-machine ip default)   -v $(pwd):/data -it  logstash  logstash  -f ./data/icgc-*.conf  -v --verbose

```

### visualization
![image](https://cloud.githubusercontent.com/assets/47808/11023573/9acaf5ce-8631-11e5-8297-42ddd015f5bb.png)

### notes

Mapping
  Elastic search does not have field level aliases.  Alternatives:
    * do nothing, let users query the differences
    * rename the fields when ETL into elastic search, educate users. ie  why their field "specimin_id" is now "sample_id"
    * copy the fields when ETL into elastic search, educate users. ie  why their field "specimin_id" is now "sample_id", but they would still be able to see their existing data (but we duplicate columns)
    Decision: copy the fields

UI alternatives
  https://github.com/OlegKunitsyn/elasticsearch-browser
  http://stackoverflow.com/questions/29602467/can-i-change-top-menu-bar-and-remove-some-options-in-kibana-4
