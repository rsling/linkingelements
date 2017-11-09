#!/bin/bash

set -e
set -u

HEADER="DocURL	DocID	SentID	LC	Match	RC	N2Num	N2Typ	N1Lemma	N1Pl	LE"
SAMPLE="400"
TMP="/tmp/__concordance__"

for f in $(ls ./Queries/Output/*.csv.gz)
do
  outfile="Concordances/$(basename ${f} '.gz')"
  itemname="$(basename ${f} '.csv.gz')"
  
  echo
  echo "${itemname}"
  echo "To file: ${outfile}"

  # Create the concordance into temp file.
  gunzip -c ${f} | tail -n +20 | head -n -2 | grep '0$' --color=never | shuf | head -n ${SAMPLE} > ${TMP}

  # Get the actual length of the concordance.
  concsize="$(wc -l ${TMP} | grep -o '^[0-9]\+')"

  # Get the N1 and LE status.
  lestatus="$(echo ${itemname} | grep -o '[01]$')"
  n1="$(echo ${itemname} | grep -o '^[^01]\+')"

  echo "${HEADER}" > ${outfile}
  paste <(cut -f1-6 ${TMP}) <(yes "NA	NA	${n1}	${lestatus}	NA" | head -n ${concsize}) >> ${outfile}

  echo "Written: ${concsize} units."
done
