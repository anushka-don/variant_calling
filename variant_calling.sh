#!bin/bash

# Download the data if not already done so
echo "  Downloading reads data and ref genome  "

curl -o read1.fastq.gz https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/007/SRR2584867/SRR2584867_1.fastq.gz

curl -o read2.fastq.gz https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/007/SRR2584867/SRR2584867_2.fastq.gz

curl -o ref_genome.fna.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/017/985/GCF_000017985.1_ASM1798v1/GCF_000017985.1_ASM1798v1_genomic.fna.gz

echo "Data Download Successful"
echo "Unzipping data"

gunzip *.gz


# Indexing Reference Genome using bwa
echo "Creating index for reference genome"

bwa index ref_genome.fna


# Aligning reads to ref
echo "Aligning reads to index"

bwa mem ref_genome.fna read1.fastq read2.fastq >output.sam


# Convert, Sort, and Index BAM
echo "Converting SAM to BAM, sorting, and indexing..."

samtools view -Sb output.sam > output.bam

samtools sort output.bam -o output_sorted.bam

samtools index output_sorted.bam


# Variant Calling
echo "Variant Calling"

bcftools mpileup -Ou -f ref_genome.fna output_sorted.bam | bcftools call -mv -Ob -o calls.bcf

bcftools view calls.bcf >calls.vcf

