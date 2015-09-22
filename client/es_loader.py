import json
import requests
import os

mapping = """
{
  "meta":{
    "properties":{
      "captureGroup":{
        "type":"double"
      },
      "coreFlowCellID":{
        "type":"string"
      },
      "coreID":{
        "type":"string"
      },
      "coreRunID":{
        "type":"string"
      },
      "coreSampleID":{
        "type":"string"
      },
      "diagnosis":{
        "type":"string"
      },
      "diagnosisClass":{
        "type":"string"
      },
      "flowCell":{
        "type":"string"
      },
      "labId":{
        "type":"string"
      },
      "lane":{
        "type":"string"
      },
      "paths":{
        "type":"string",
        "index_name" : "path"
      },
      "patientId":{
        "type":"double"
      },
      "rnaseq":{
        "type":"string"
      },
      "secondarySpecificDiagnosis":{
        "type":"string"
      },
      "seqcap":{
        "type":"string"
      },
      "seqcapGroupName":{
        "type":"string"
      },
      "specificDiagnosis":{
        "type":"string"
      },
      "tertiarySpecificDiagnosis":{
        "type":"string"
      }
    }
  }
}

"""



# grab meta from disk
metas = json.loads(open("meta.json").read())
assert metas,"failed, could not load from meta.json"
servers = os.environ['elastic_search_servers'].split(",")
assert servers,"failed, elastic_search_servers not set"
server_index = list(range(len(servers)))

# define mapping
for s in server_index:
    # create index
    url = "http://%s/meta_index_%s" % (servers[s],s)
    response = requests.put(url)
    assert response.status_code in (200,201),response.json()

    url = "http://%s/meta_index_%s/_mapping/meta" % (servers[s],s)
    response = requests.put(url, data=mapping)
    assert response.status_code in (200,201),response.json()


# load meta
s = 0
for meta in metas:
    url = "http://%s/meta_index_%s/meta/%s" % (servers[s],s,meta['labId'])
    response = requests.put(url, data=json.dumps(meta))
    assert response.status_code in (200,201),response.json()
    s += 1
    if not s in server_index:
        s = 0
