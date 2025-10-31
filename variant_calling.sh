#!bin/bash

# Create Directories
mkdir data
mkdir ref_genome
mkdir results

# Download the data if not already done so
echo "  Downloading reads data and ref genome  "

curl -o data/read1.fastq.gz https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/007/SRR2584867/SRR2584867_1.fastq.gz

curl -o data/read2.fastq.gz https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/007/SRR2584867/SRR2584867_2.fastq.gz

curl -o ref_genome/ref_genome.fna.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/017/985/GCF_000017985.1_ASM1798v1/GCF_000017985.1_ASM1798v1_genomic.fna.gz

echo "Data Download Successful"
echo "Unzipping data"

gunzip data/*.gz
gunzip ref_genome/*.gz


# Indexing Reference Genome using bwa
echo "Creating index for reference genome"
cd ref_genome
bwa index ref_genome.fna
cd ..


# Aligning reads to ref
echo "Aligning reads to index"

bwa mem ref_genome/ref_genome.fna data/read1.fastq data/read2.fastq >results/aligned.sam


# Convert, Sort, and Index BAM
echo "Converting SAM to BAM, sorting, and indexing..."

samtools view -Sb results/aligned.sam > results/aligned.bam

samtools sort results/aligned.bam -o results/sorted_aligned.bam

samtools index results/sorted_aligned.bam


# Variant Calling
echo "Variant Calling"

bcftools mpileup -Ou -f ref_genome/ref_genome.fna results/sorted_aligned.bam | bcftools call -mv -Ob -o results/calls.bcf

bcftools view results/calls.bcf > results/calls.vcf

