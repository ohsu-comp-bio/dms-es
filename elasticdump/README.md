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

# Backup index data to a file (ie : stored in $pwd/data) :
docker run --rm -ti -v $(pwd)/data:/data elasticdump \
  --all=true --input=http://$(docker-machine ip default):9200 \
   --input-index=/ \
   --output=/data/snapshot.js

# restore
docker run --rm -ti -v $(pwd)/data:/data elasticdump \
--bulk=true --input=/data/snapshot.js \
--output=http://$(docker-machine ip default):9200/

```




 [See more on github](https://github.com/taskrabbit/elasticsearch-dump)
