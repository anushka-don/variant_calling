#!bin/bash

# Create a directory to store analysis
mkdir analysis

# Analysis of the variant files
echo "/n/nVariants in the given reads:/n"
grep -v "^#" results/calls.vcf | wc -l 

# 