#Metadata - Elastic Search Proof of Concept
---
### In scope: _3 month plan_ - federated query, aml meta , simulate DMS ETL

### Out of scope: LDAP, central function,etc.

![image](https://cloud.githubusercontent.com/assets/47808/10010059/5a2f5bd4-609a-11e5-9898-1194f869dd43.png)

---




##pre-processing  `client/spreadsheet_parser.py`
####datasource

```
/mnt/lustre1/BeatAML/rnaseq/BeatAML_rnaseq_YYYY_MM_DD_public_dashboard.xlsx
/mnt/lustre1/BeatAML/seqcap/BeatAML_seqcap_YYYY_MM_DD_public_dashboard.xlsx
```

* run from `exacloud`
* convert xls & directory to json
* process "Sample Summary" tab
  * Normalize attribute names to camelCase
  * Construct file paths 	

	###seqcap attribute names
	|As-Is|To-Be|
	|---|---|
	|LabID|labId|
	|Patient.ID|patientId|
	|Diagnosis|diagnosis|
	|Specific.Diagnosis|specificDiagnosis|
	|Secondary.Specific.Diagnosis|secondarySpecificDiagnosis|
	|Tertiary.Specific.Diagnosis|tertiarySpecificDiagnosis|
	|DiagnosisClass|diagnosisClass|
	|seqcap_GroupName|seqcapGroupName|
	|CaptureGroup|captureGroup|
	|FlowCell|flowCell|
	|Lane|lane|
	|CoreID|coreID|
	|CoreRunID|coreRunID|
	|CoreFlowCellID|coreFlowCellID|
	|CoreSampleID|coreSampleID|
	|seqcap|seqcap|
	|rnaseq|rnaseq|
	|paths|[path1,path2,...]|
	
	
	
	### final structure
![image](https://cloud.githubusercontent.com/assets/47808/10010107/eae23cdc-609a-11e5-8ec5-7adf92f17dbd.png)
	
	http://yuml.me/87a022e1
	
##elastic search `client/es_loader.py`
* run from any host with access to elastic search
* spreads meta data across 1..N elastic search instances
* this layer will evolve to ETS from DMS
	
## docker

* see docker/elasticsearch  for the dockerfile to for the elasticsearch image `elasticsearch:ccc`

* see clusters/README.md for notes on starting ES cluster, etc (in progress)


## ui
see `kibana startup` in cluster/

http://$(docker-machine ip default)/5601 


### discovery
![image](https://cloud.githubusercontent.com/assets/47808/10038486/9773596e-617b-11e5-82f5-347fd4a62c19.png)

### visualization
**TODO**	