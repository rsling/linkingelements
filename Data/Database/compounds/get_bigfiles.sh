#!/bin/bash

set -e
set -u

wget https://www.webcorpora.org/projectdata/decowcompounds/compounds+.csv.gz
wget https://www.webcorpora.org/projectdata/decowcompounds/compounds+s.csv.gz
wget https://www.webcorpora.org/projectdata/decowcompounds/decow16ax_comps.txt.gz
wget https://www.webcorpora.org/projectdata/decowcompounds/decow16ax_comps_counts.txt.gz
wget https://www.webcorpora.org/projectdata/decowcompounds/decow16ax_nouns_counts.csv.gz

gunzip compounds+.csv.gz compounds+s.csv.gz decow16ax_comps.txt.gz decow16ax_comps_counts.txt.gz decow16ax_nouns_counts.csv.gz
