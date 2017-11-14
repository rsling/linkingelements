#!/bin/bash

set -e
set -u

INPUTS="Concordances/*.csv"
OUTFILE1="Concordance.csv"
# OUTFILE2="Concordance.full.csv"

head -n 1 $(ls -1 ${INPUTS} | head -n 1) | cut -f 1,2,3,7,8,9,10,11 > ${OUTFILE1} 
# head -n 1 $(ls -1 ${INPUTS} | head -n 1) > ${OUTFILE2} 

for f in $(ls -1 ${INPUTS})
do
  tail -n +2 "${f}" | cut -f 1,2,3,7,8,9,10,11 | grep -v '	?	' >> ${OUTFILE1}
  # tail -n +2 "${f}" >> ${OUTFILE2}
done

