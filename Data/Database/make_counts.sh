#!/bin/bash

set -e
set -u

noun="[A-ZÄÖÜ][a-zäöüßéè]\+"

get_hapax() {
  echo
  echo "Getting hapax count for linking element '${suffix}'..."
  cat compounds/decow16ax_comps_counts.txt |
    grep "\s${noun}${snippet}${noun}$" |
    grep '\(^\|\s\)1\s' |
    sed 's/^\s*1\s\([^_]\+\)_.\+$/\1/' |
    sort -T . -S 4G --compress-program=gzip |
    uniq -c |
    sort -T . -S 4G --compress-program=gzip -nr |
    sed 's/\s*\([0-9]\+\)\s\+\([^ ]\+\)$/\2	\1/' > fhapax/fhapax${suffix}.csv
}

get_types() {
  echo
  echo "Getting type count for linking element '${suffix}'..."
  cat compounds/decow16ax_comps_counts.txt |
    grep "\s${noun}${snippet}${noun}$" |
    sed 's/^\s*[0-9]\+\s\([^_]\+\)_.\+$/\1/' |
    sort -T . -S 4G --compress-program=gzip |
    uniq -c |
    sort -T . -S 4G --compress-program=gzip -nr |
    sed 's/\s*\([0-9]\+\)\s\+\([^ ]\+\)$/\2	\1/' > ftype/ftype${suffix}.csv
}

get_tokens() {
  echo
  echo "Getting token count for linking element' ${suffix}'..."
  cat compounds/decow16ax_comps.txt |
    grep "^${noun}${snippet}${noun}$" |
    sed 's/\([^_]\+\)_.\+$/\1/' |
    sort -T . -S 4G --compress-program=gzip |
    uniq -c |
    sort -T . -S 4G --compress-program=gzip -nr |
    sed 's/\s*\([0-9]\+\)\s\+\([^ ]\+\)$/\2	\1/' > ftoken/ftoken${suffix}.csv
}


get_all() {
  get_hapax
  get_types
  get_tokens
}


do_it() {
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
  
  snippet='_-e_'
  suffix='-e'
  get_all

  snippet='_+ens_'
  suffix='+ens'
  get_all

  snippet='_+ns_'
  suffix='+ns'
  get_all

  echo
  echo "NOTE: Getting the counts for '+' takes exceptionally long!"
  snippet='_'
  suffix='+'
  get_all
  
  echo
  echo "NOTE: Getting the counts for '+s' takes exceptionally long!"
  snippet='\(_(e)_+s_\|_+s_\)'
  suffix='+s'
  get_all
  
  echo
  echo "NOTE: Getting the counts for 'NOT PLURAL' takes exceptionally long!"
  snippet='\(_(e)_+s_\|_+s_\|_\|_-e_\|_+ens_\|_+ns_\)'
  suffix='+NP'
  get_all
}


echo
echo "*********************************************"
echo "* This script may take many minutes to run. *"
echo "* On my high-performance MacBook: hours.    *"
echo "*********************************************"
echo

echo "This will refresh the token/type/hapax counts for"
echo "all N1 in N1+N2 compounds. These lists come with"
echo "the data package, and this script is only included"
echo "for documentation purposes. Continue?"
echo "(Please type the appropriate number.)"

select yn in "Yes" "No"; do
    case $yn in
        Yes ) do_it; break;;
        No ) exit;;
    esac
done
