#!/bin/bash

# This extracts the N1 and compound data for N1+N2 compounds
# from the large DECOW16A compound data base as provided by
# the COW project.

# This script is provided just for documentation purposes.
# All relevant data is also included in the data package.

set -e
set -u

noun="[A-ZÄÖÜ][a-zäöüßéè]\+"

get_n1() {
  echo
  echo "Getting N1s for linking element '${suffix}'..."
  cat compounds/decow16ax_comps_counts.txt |
    grep "\s${noun}${snippet}${noun}$" |
    sed 's/^\s*[0-9]\+\s\([^_]\+\)_.\+$/\1/' |
    sort -T . -S 4G --compress-program=gzip |
    uniq > n1/n1${suffix}.txt
}

get_compounds() {
  echo
  echo "Getting compound type count for linking element '${suffix}'..."
  cat compounds/decow16ax_comps_counts.txt |
    grep "\s${noun}${snippet}${noun}$" |
    sed "s/${snippet}/	/" |
    sed "s/^\s*\([0-9]\+\)\s\+\(${noun}\)	\(${noun}\)$/\2	\3	\1/" > compounds/compounds${suffix}.csv
}

get_all() {
  get_n1
  get_compounds
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
  
  snippet='_'
  suffix='+'
  get_all
  
  snippet='\(_(e)_+s_\|_+s_\)'
  suffix='+s'
  get_all
}


echo
echo "*********************************************"
echo "* This script may take many minutes to run. *"
echo "* On my high-performance MacBook: 2 min.    *"
echo "*********************************************"
echo

echo "This will refresh the lists of N1 as well as the"
echo "compound frequencies. These lists come with the"
echo "data package, and this script is only included"
echo "for documentation purposes. Continue?"
echo "(Please type the appropriate number.)"

select yn in "Yes" "No"; do
    case $yn in
        Yes ) do_it; break;;
        No ) exit;;
    esac
done
