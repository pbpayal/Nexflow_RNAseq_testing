#!/bin/bash
#SBATCH --job-name=star_nf
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=06:00:00
#SBATCH --partition=norm
#SBATCH --output=logs/star_%j.out
#SBATCH --error=logs/star_%j.err

# Load Nextflow and STAR
module load nextflow
module load STAR/2.7.8a

# Run the Nextflow pipeline
nextflow run star.nf \
  --reads 'fastq/*_{1,2}.fastq.gz' \
  --genomeDir 'ref/chrX.fa' \
  --gtf 'ref/chrX.gtf'

