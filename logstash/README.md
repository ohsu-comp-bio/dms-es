
# from logstash dir
docker run  -v $(pwd):/data -it  logstash  logstash  -f ./data/icgc-*.conf  -v --verbose  --debug rspecUsing Accessor#strict_set for specs
