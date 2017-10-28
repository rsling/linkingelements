#!/bin/bash

set -e
set -u

SERVER="https://www.webcorpora.org/projectdata/decowcompounds/"
LOCAL="Database/compounds/"
LOCALR="R/RData/"
FILES=( "compounds+.csv.gz" "compounds+s.csv.gz" "decow16ax_comps.txt.gz" "decow16ax_comps_counts.txt.gz" "decow16ax_nouns_counts.csv.gz" )
RFILES=( "noun.frequencies.RData" )

for f in ${FILES[@]}
do
  echo 
  echo "REMOTE: ${SERVER}${f} -> LOCAL: ${LOCAL}${f}"
  echo "Downloading..."
  wget "${SERVER}${f}" -O "${LOCAL}${f}"
  echo "Unzipping..."
  gunzip -f "${LOCAL}${f}"
done

for f in ${RFILES[@]}
do
  echo 
  echo "REMOTE: ${SERVER}${f} -> LOCAL: ${LOCALR}${f}"
  echo "Downloading..."
  wget "${SERVER}${f}" -O "${LOCALR}${f}"
done
