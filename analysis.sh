#!bin/bash

# Create a directory to store analysis
mkdir -p analysis

# Analysis of the variant files
echo -e "\n\nVariants in the given reads:\n"
grep -v "^#" results/calls.vcf | wc -l 

# Count SNPs
echo -e "\nCount SNPs:\n"
bcftools stats results/calls.vcf | grep "number of SNPs"

# Count insertions/deletions
echo -e "\n\nCount insertions/deletions:\n"
grep -v "^#" results/calls.vcf | awk 'length($4)!=length($5)' | wc -l

# Summary with bcftools
echo -e "\n\nGet Summary with bcftools\n"
bcftools stats results/calls.vcf > analysis/stats.txt
echo -e "\n\nSaved Results in analysis/stats/txt\n"

# Filtering High-Quality Variants
echo -e "\n\nFilter High-Quality Variants\n"
bcftools filter -i 'QUAL>50 && DP>10' results/calls.vcf -Ov -o analysis/highconf.vcf
echo -e "\n\nSaved results in analysis/highconf.vcf\n"