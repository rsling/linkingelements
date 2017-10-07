#!/bin/bash

set -e
set -u

gunzip -c ${1} | cut -s -f9 | grep -v '^_$' | sort -T . -S 5G > $(basename ${1} .xml.gz)_comps.txt
