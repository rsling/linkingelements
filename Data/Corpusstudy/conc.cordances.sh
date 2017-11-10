#!/bin/bash

set -e
set -u

INPUTS="Concordances/*.csv"
OUTFILE="Concordance.csv"

head -n 1 $(ls -1 ${INPUTS} | head -n 1) | cut -f 1,2,3,7,8,9,10,11 > ${OUTFILE} 

for f in $(ls -1 ${INPUTS})
do
  tail -n +2 "${f}" | cut -f 1,2,3,7,8,9,10,11 | grep -v '	?	' >> ${OUTFILE}
done

