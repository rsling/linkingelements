#!/bin/bash

# Pass directory with Queries as only param.

set -e
set -u

of="Typefreq_${1}.csv"

echo -e "N1\tF_LE\tHAPAX_LE\tF_NLE\tHAPAX_NLE" > ${of}

for l in $(ls ../${1} | sed 's/_\(nle\|le\)\.tsv//' | sort -u)
do
  fle="../${1}/${l}_le.tsv"
  fnle="../${1}/${l}_nle.tsv"
  tfle=$(tail -n +20 ${fle} | cut -f 5 | sed 's/|.\+//' | sort -u | wc -l)
  hapaxle=$(tail -n +20 ${fle} | cut -f 5 | sed 's/|.\+//' | sort | uniq -u | wc -l)
  tfnle=$(tail -n +20 ${fnle} | cut -f 5 | sed 's/|.\+//' | sort -u | wc -l)
  hapaxnle=$(tail -n +20 ${fnle} | cut -f 5 | sed 's/|.\+//' | sort | uniq -u | wc -l)
  echo -e "${l}\t${tfle}\t${hapaxle}\t${tfnle}\t${hapaxnle}" >> ${of}
done