#!/bin/bash

# This generates normal blacklists from the annotated blacklists files.
# In those files, leading - marks general wrong entires, while leading #
# marks weak nouns, which we also exclude from the study because the
# morph -(e)n, which is used as a linking element, is not uniquely a
# plural marker (also Acc/Dat/Gen Sg).

set -e
set -u

for f in $(ls -1 n1/blacklist*.txt)
do
  out_file="$(dirname ${f})/real_$(basename ${f})"
  grep '^[#-]' ${f} | tr -d '-' | tr -d '#' > ${out_file}
done

