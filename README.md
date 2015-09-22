#Metadata
##datasource

```
/mnt/lustre1/BeatAML/rnaseq/BeatAML_rnaseq_YYYY_MM_DD_public_dashboard.xlsx
/mnt/lustre1/BeatAML/seqcap/BeatAML_seqcap_YYYY_MM_DD_public_dashboard.xlsx
```


##pre-processing  `client/spreadsheet_parser.py`
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
	
	http://yuml.me/87a022e1
	
##elastic search `client/es_loader.py`
* run from any host with access to elastic search
* spreads meta data across 1..N elastic search instances
	