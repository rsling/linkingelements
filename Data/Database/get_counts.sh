#!/bin/bash

set -e
set -u

noun="[A-ZÄÖÜ][a-zäöüßéè]\+"

get_hapax() {
  echo "Getting hapax count for ${suffix}..."
  cat compounds/decow16ax_comps_counts.txt |
    grep "\s${noun}${snippet}${noun}$" |
    grep '\(^\|\s\)1\s' |
    sed 's/^\s*1\s\([^_]\+\)_.\+$/\1/' |
    sort -T . -S 4G --compress-program=gzip |
    uniq -c |
    sort -T . -S 4G --compress-program=gzip -nr |
    sed 's/\s*\([0-9]\+\)\s\+\([^ ]\+\)$/\2	\1/' > fhapax/fhapax_${suffix}.csv
}

get_types() {
  echo "Getting type count for ${suffix}..."
  cat compounds/decow16ax_comps_counts.txt |
    grep "\s${noun}${snippet}${noun}$" |
    sed 's/^\s*[0-9]\+\s\([^_]\+\)_.\+$/\1/' |
    sort -T . -S 4G --compress-program=gzip |
    uniq -c |
    sort -T . -S 4G --compress-program=gzip -nr |
    sed 's/\s*\([0-9]\+\)\s\+\([^ ]\+\)$/\2	\1/' > ftype/ftype_${suffix}.csv
}

get_tokens() {
  echo "Getting token count for ${suffix}..."
  cat compounds/decow16ax_comps.txt |
    grep "^${noun}${snippet}${noun}$" |
    sed 's/\([^_]\+\)_.\+$/\1/' |
    sort -T . -S 4G --compress-program=gzip |
    uniq -c |
    sort -T . -S 4G --compress-program=gzip -nr |
    sed 's/\s*\([0-9]\+\)\s\+\([^ ]\+\)$/\2	\1/' > ftoken/ftoken_${suffix}.csv
}


get_all() {
  get_hapax
  get_types
  get_tokens
}

echo
echo "*********************************************"
echo "* This script may take many minutes to run! *"
echo "*********************************************"
echo

snippet='_+er_'
suffix='+er'
get_all

snippet='_+=er_'
suffix='+Uer'
get_all

snippet='_+e_'
suffix='+e'
get_all

snippet='_+=e_'
suffix='+Ue'
get_all

snippet='_+n_'
suffix='+n'
get_all

snippet='_+en_'
suffix='+en'
get_all

snippet='_+=en_'
suffix='+Uen'
get_all

snippet='_+=_'
suffix='+U'
get_all

snippet='_'
suffix='+'
get_all

snippet='\(_(e)_+s_\|_+s_\)'
suffix='+s'
get_all

