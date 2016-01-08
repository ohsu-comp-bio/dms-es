elasticdump
==================



### Docker install
If you prefer using docker to use elasticdump, you can clone this git repo and run :

```bash
docker build -t elasticdump .
```
Then you can use it just by :
- using `docker run --rm -ti elasticdump`
- remembering that you cannot use `localhost` or `127.0.0.1` as you ES host ;)
- you'll need to mount your file storage dir `-v <your dumps dir>:<your mount point>` to your docker container

Example:

```bash

# Backup all index data to a file (ie : stored in $pwd/data/snapshot.json) :
docker run --rm -ti -v $(pwd)/data:/data elasticdump \
  --all=true --input=http://$(docker-machine ip default):9200 \
  --input-index=/ \
  --output=/data/snapshot.json

# restore all data
docker run --rm -ti -v $(pwd)/data:/data elasticdump \
--bulk=true --input=/data/snapshot.json \
--output=http://$(docker-machine ip default):9200/

# settings are not backed up, so reset them explicitly
curl -XPUT  $(docker-machine ip default):9200/.kibana/_settings \
  -d '{ "index" : { "max_result_window" : 2147483647 } }'

```




 [See more on github](https://github.com/taskrabbit/elasticsearch-dump)
