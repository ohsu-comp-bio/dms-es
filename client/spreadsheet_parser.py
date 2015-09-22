#!/usr/bin/env python
"""
Extract BeatAML meta information from spreadsheet and /mnt/lustre1/BeatAML/ directories
Export as JSON
"""

import collections
import xlrd
import glob

def extractPaths(meta):
    """
    Given a meta object ( a row from the spreadsheet) deduce the
    contruct a set of paths
    """
    # these two should be the same length
    flowCells = meta['flowCell'].split(';')
    coreRunIDs = meta['coreRunID'].split(';')
    paths = []
    for i in range(0,len(flowCells)):
        flowCell = flowCells[i]
        coreRunID =coreRunIDs[i]
        path = "/mnt/lustre1/BeatAML/seqcap/raw/%s/FlowCell%s/%s/Sample_%s" \
            % (meta['seqcapGroupName'],flowCell,coreRunID,meta['coreSampleID'])
        paths.extend( glob.glob(path+ "/*")  )
    return paths

def main():
    # columns in BeatAML_seqcap_YYYY_MM_DD_public_dashboard.xlsx
    camelCaseDict = collections.OrderedDict()
    camelCaseDict['LabID'] = 'labId'
    camelCaseDict['Patient.ID'] = 'patientId'
    camelCaseDict['Diagnosis'] = 'diagnosis'
    camelCaseDict['Specific.Diagnosis'] = 'specificDiagnosis'
    camelCaseDict['Secondary.Specific.Diagnosis'] = 'secondarySpecificDiagnosis'
    camelCaseDict['Tertiary.Specific.Diagnosis'] = 'tertiarySpecificDiagnosis'
    camelCaseDict['DiagnosisClass'] = 'diagnosisClass'
    camelCaseDict['seqcap_GroupName'] = 'seqcapGroupName'
    camelCaseDict['CaptureGroup'] = 'captureGroup'
    camelCaseDict['FlowCell'] = 'flowCell'
    camelCaseDict['Lane'] = 'lane'
    camelCaseDict['CoreID'] = 'coreID'
    camelCaseDict['CoreRunID'] = 'coreRunID'
    camelCaseDict['CoreFlowCellID'] = 'coreFlowCellID'
    camelCaseDict['CoreSampleID'] = 'coreSampleID'
    camelCaseDict['seqcap'] = 'seqcap'
    camelCaseDict['rnaseq'] = 'rnaseq'
    # open the spreadsheet
    book  = xlrd.open_workbook('/mnt/lustre1/BeatAML/seqcap/BeatAML_seqcap_2015_08_13_public_dashboard.xlsx')
    assert book, "failed, could not open spreadsheet"
    sheet = book.sheet_by_name('Sample Summary')
    assert sheet, "failed, could not open 'Sample Summary' work sheet"
    # check to ensure that the column names are expected
    row = sheet.row(0)
    headers = camelCaseDict.keys()
    ok = True
    for idx, cell_obj in enumerate(row):
        if not any (cell_obj.value in s for s in headers):
            print('unknown column (%s) %s' % (idx,  cell_obj.value))
            ok = False
    assert ok, "failed due to unknown column"
    # extract the meta
    metas = []
    for r in range(1, sheet.nrows):
        meta = collections.OrderedDict()
        for c in range(0,len(headers)):
            meta[camelCaseDict[headers[c]]] = sheet.cell(r, c).value
        meta['paths'] = extractPaths(meta)
        metas.append(meta)
    print metas


if __name__ == '__main__':
    main()
