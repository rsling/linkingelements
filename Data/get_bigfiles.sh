#!/bin/bash

set -e
set -u

SERVER="https://www.webcorpora.org/projectdata/decowcompounds/"
LOCAL="Database/compounds/"
LOCALR="R/RData/"
FILES=( "compounds+.csv.gz" "compounds+s.csv.gz" "compounds+NP.csv.gz" "decow16ax_comps.txt.gz" "decow16ax_comps_counts.txt.gz" "decow16ax_nouns_counts.csv.gz")
RFILES=( "noun.frequencies.RData" )

QUERIES=( "Apfel0.csv.gz" "Apfel1.csv.gz" "Auge0.csv.gz" "Auge1.csv.gz" "Bad0.csv.gz" "Bad1.csv.gz" "Ball0.csv.gz" "Ball1.csv.gz" "Bauer0.csv.gz" "Bauer1.csv.gz" "Beere0.csv.gz" "Beere1.csv.gz" "Bett0.csv.gz" "Bett1.csv.gz" "Bild0.csv.gz" "Bild1.csv.gz" "Birne0.csv.gz" "Birne1.csv.gz" "Brett0.csv.gz" "Brett1.csv.gz" "Brief0.csv.gz" "Brief1.csv.gz" "Buch0.csv.gz" "Buch1.csv.gz" "Bucht0.csv.gz" "Bucht1.csv.gz" "Dämon0.csv.gz" "Dämon1.csv.gz" "Definition0.csv.gz" "Definition1.csv.gz" "Ei0.csv.gz" "Ei1.csv.gz" "Eigenschaft0.csv.gz" "Eigenschaft1.csv.gz" "Element0.csv.gz" "Element1.csv.gz" "Frau0.csv.gz" "Frau1.csv.gz" "Gerät0.csv.gz" "Gerät1.csv.gz" "Geräusch0.csv.gz" "Geräusch1.csv.gz" "Geschenk0.csv.gz" "Geschenk1.csv.gz" "Gitarre0.csv.gz" "Gitarre1.csv.gz" "Hand0.csv.gz" "Hand1.csv.gz" "Haus0.csv.gz" "Haus1.csv.gz" "Hemd0.csv.gz" "Hemd1.csv.gz" "Horde0.csv.gz" "Horde1.csv.gz" "Hund0.csv.gz" "Hund1.csv.gz" "Hüfte0.csv.gz" "Hüfte1.csv.gz" "Instrument0.csv.gz" "Instrument1.csv.gz" "Katze0.csv.gz" "Katze1.csv.gz" "Kind0.csv.gz" "Kind1.csv.gz" "Kommune0.csv.gz" "Kommune1.csv.gz" "Kunde0.csv.gz" "Kunde1.csv.gz" "Lied0.csv.gz" "Lied1.csv.gz" "Loch0.csv.gz" "Loch1.csv.gz" "Mehrheit0.csv.gz" "Mehrheit1.csv.gz" "Mutter0.csv.gz" "Mutter1.csv.gz" "Nagel0.csv.gz" "Nagel1.csv.gz" "Nation0.csv.gz" "Nation1.csv.gz" "Ohr0.csv.gz" "Ohr1.csv.gz" "Person0.csv.gz" "Person1.csv.gz" "Portion0.csv.gz" "Portion1.csv.gz" "Produkt0.csv.gz" "Produkt1.csv.gz" "Projektor0.csv.gz" "Projektor1.csv.gz" "Rad0.csv.gz" "Rad1.csv.gz" "Schloss0.csv.gz" "Schloss1.csv.gz" "Schwert0.csv.gz" "Schwert1.csv.gz" "Schwester0.csv.gz" "Schwester1.csv.gz" "Sonne0.csv.gz" "Sonne1.csv.gz" "Stadt0.csv.gz" "Stadt1.csv.gz" "Strauch0.csv.gz" "Strauch1.csv.gz" "Universität0.csv.gz" "Universität1.csv.gz" "Vater0.csv.gz" "Vater1.csv.gz" "Vogel0.csv.gz" "Vogel1.csv.gz" "Weg0.csv.gz" "Weg1.csv.gz" "Wurm0.csv.gz" "Wurm1.csv.gz" "Zahn0.csv.gz" "Zahn1.csv.gz" "Zitat0.csv.gz" "Zitat1.csv.gz" )
QUERIESOUT="Corpusstudy/Queries/Output/"


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

mkdir -p ${QUERIESOUT} 
for f in ${QUERIES[@]}
do
  wget "${SERVER}/queries/${f}" -P "${QUERIESOUT}"
done
 
