#!/bin/bash

set -e
set -u

for f in $(ls -1 blacklist*.txt)
do
  out_file="real_${f}"
  grep '^-' ${f} | tr -d '-' > ${out_file}
done

