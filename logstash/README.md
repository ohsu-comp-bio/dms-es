
# from logstash dir
docker run  -v $(pwd):/data -it  logstash  logstash  -f ./data/icgc-*.conf  -v --verbose  --debug rspecUsing Accessor#strict_set for specs



## logstash

* from logstash dir
docker run  -v $(pwd):/data -it  logstash  logstash  -f ./data/icgc-*.conf  -v --verbose  --debug rspecUsing Accessor#strict_set for specs

curl -XDELETE 'http://192.168.99.100:9201/*-icgc/'

docker run  --add-host elasticsearch:192.168.99.100   -v $(pwd):/data -it  logstash  logstash  -f ./data/icgc-*.conf  -v --verbose

## Data summary

The initial data uses the following entities:

1) patient/individual: attributes for a single patient

2) sample/specimen: attributes for a single sample taken from a patient

3) dataset: this is the most complex entity.  operationally, this tends to be an 'actionable' unit of data.  for example, genomic data will have a collection of FASTQ files that commprises one genome.  This unit of data is an input for a pipeline, and this unit of data would be one dataset.  In the case of images, this one dataset might be a single file.  If the user is browsing data and wants to ask 'does the patient have RNA-Seq data', this is the level where I assume they are querying.

4) resource: each resource is roughly equal to one file.  however, in theory this could be a GA4GH entity or similar non-files.

The sample TSVs have been extensivle denormalized, such that all attributes of the patient are applied to the sample, all attributes of the patient + sample are applied to the dataset, etc.
