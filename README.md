# Variant Calling and Analysis Pipeline

This repository contains a Bash-based workflow for variant calling and analysis using next-generation sequencing (NGS) data. The pipeline automates the process of downloading raw reads and a reference genome, aligning reads, calling variants, and performing variant statistics and filtering.

---
## Overview

This pipeline performs the following steps:

1. Setup and Data Retrieval

   * Creates directories for data, reference genome, and results.
   * Downloads paired-end sequencing reads and a reference genome from public databases (SRA and NCBI).
   * Decompresses the downloaded files.

2. Reference Genome Indexing

   * Indexes the reference genome using BWA for efficient alignment.

3. Read Alignment

   * Aligns paired-end reads to the reference genome using `bwa mem`.
   * Converts SAM → BAM → sorted BAM → indexed BAM using SAMtools.

4. Variant Calling

   * Performs variant calling using BCFtools to generate `.bcf` and `.vcf` files.

5. Variant Analysis

   * Counts total variants, SNPs, and indels.
   * Generates summary statistics with `bcftools stats`.
   * Filters high-confidence variants based on quality (`QUAL > 50`) and read depth (`DP > 10`).

---

## Tools and Technologies Used

* Bash – For workflow automation
* BWA – Reference genome indexing and read alignment
* SAMtools – File conversion, sorting, and indexing
* BCFtools – Variant calling, filtering, and summary statistics
* curl and gunzip – For data retrieval and decompression

---

## Problem Solved

This script provides a reproducible, automated pipeline for performing variant calling from NGS data.
It eliminates manual steps in data retrieval, alignment, and variant analysis—helping users quickly generate and analyze variant files for downstream biological interpretation.

---

## Usage

1. Clone this repository:

   ```bash
   git clone https://github.com/<your-username>/<repo-name>.git
   cd <repo-name>
   ```

2. Make the script executable:

   ```bash
   chmod +x variant_pipeline.sh
   ```

3. Run the pipeline:

   ```bash
   ./variant_pipeline.sh
   ```

---

## Output

* `results/`

  * `aligned.sam`, `sorted_aligned.bam`, `calls.vcf`

* `analysis/`

  * `stats.txt`: Summary of variants
  * `highconf.vcf`: Filtered high-confidence variants

---

## Example Summary Output

```bash
Variants in the given reads:  125
Count SNPs:                  120
Count insertions/deletions:  5
```

