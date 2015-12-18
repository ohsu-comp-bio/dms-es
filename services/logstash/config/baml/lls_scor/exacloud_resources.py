#!/usr/bin/env python
"""
Extract BeatAML meta information from spreadsheet and /mnt/lustre1/BeatAML/ directories
Export as JSON
"""

import collections
import csv
import glob
import json
import subprocess

def locate(pattern, root=os.curdir):
    findCMD = 'find '+root+' -name "'+pattern+'"'
    out = subprocess.Popen(findCMD,shell=True,stdin=subprocess.PIPE,
                            stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    # Get standard out and error
    (stdout, stderr) = out.communicate()
    # Save found files to list
    filelist = stdout.decode().split()
    return filelist

def main():
    with open('lls_scor-specimen.tsv','rb') as tsvin:
        with open('lls_scor-resource.tsv', 'wb') as tsvout:
            tsvin = csv.reader(tsvin, delimiter='\t')
            tsvout = csv.writer(tsvout, delimiter='\t')
            c = 0
            for row in tsvin:
                if c > 0:
                    files = locate(pattern='*'+row[2]+'*', root="/mnt/lustre1/BeatAML/")
                else
                    tsvout.writerow([row[0],row[1],row[2]],'path')
                c = c + 1
                for file in files:
                    tsvout.writerow([row[0],row[1],row[2]],file)

if __name__ == '__main__':
    main()
