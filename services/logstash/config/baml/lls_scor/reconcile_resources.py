#!/usr/bin/env python
"""
Extract BeatAML meta information from spreadsheet and /mnt/lustre1/BeatAML/ directories
Export as JSON
"""

import collections
import csv


def main():

    with open('formula_extract_filename_filepaths.txt', mode='rb') as infile:
      reader = csv.reader(infile, delimiter='\t')
      mydict = {rows[1]:rows for rows in reader}

    with open('lls_scor-resource-reconciled.tsv', 'wb') as tsvout:
        tsvout = csv.writer(tsvout, delimiter='\t')
        with open('lls_scor-resource.tsv','rb') as tsvin:
            tsvin = csv.reader(tsvin, delimiter='\t')
            for row in tsvin:
                if row[3].find('.') > -1:
                    a = []
                    if(mydict.get(row[3])):
                        a = mydict.get(row[3])
                    row.extend(a)
                    tsvout.writerow(row)

if __name__ == '__main__':
    main()
