
# from logstash dir
docker run  -v $(pwd):/data -it  logstash  logstash  -f ./data/icgc-*.conf  -v --verbose  --debug rspecUsing Accessor#strict_set for specs



## logstash

* from logstash dir
docker run  -v $(pwd):/data -it  logstash  logstash  -f ./data/icgc-*.conf  -v --verbose  --debug rspecUsing Accessor#strict_set for specs

curl -XDELETE 'http://192.168.99.100:9201/*-icgc/'

docker run  --add-host elasticsearch:192.168.99.100   -v $(pwd):/data -it  logstash  logstash  -f ./data/icgc-*.conf  -v --verbose
