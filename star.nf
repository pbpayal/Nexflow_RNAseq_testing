#!/usr/bin/env nextflow

nextflow.enable.dsl=2

// Input parameters
params.reads      = '/data/NHGRImito/Payal/Nexflow_test/test_proj/fastq/*_chrX_{1,2}.fastq.gz'  // Glob pattern for paired-end reads
params.genomeDir  = '/data/NHGRImito/Payal/Nexflow_test/test_proj/INDEX/index'
params.gtf        = '/data/NHGRImito/Payal/Nexflow_test/test_proj/ref/chrX.gtf'
params.outdir     = 'star_output'



// Check required parameters
if (!params.genomeDir || !params.gtf) {
    error "Missing required parameters: --genomeDir and/or --gtf"
}

// Process to run STAR
process STAR_ALIGN {
    tag "${sample_id}"

    publishDir "${params.outdir}", mode: 'copy'

    // Automatically handle resources using nextflow.config
//    module 'STAR'  // Ensures STAR is loaded on Biowulf

    input:
	tuple val(sample_id), path(reads)
        path genomeDir
        path gtf

    output:
    path "${sample_id}_Aligned.sortedByCoord.out.bam"
    path "${sample_id}_ReadsPerGene.out.tab"

    script:
    """
      echo "Processing sample: ${sample_id}"
      echo "Reading files: ${reads[0]} and ${reads[1]}"

    STAR \
        --runThreadN 16 \
        --runMode alignReads \
        --readFilesCommand zcat \
        --readFilesIn "${reads[0]}" "${reads[1]}" \
        --genomeDir ${genomeDir} \
        --sjdbGTFfile ${gtf} \
        --twopassMode Basic \
        --outSAMtype BAM SortedByCoordinate \
        --outSAMunmapped Within \
        --quantMode GeneCounts \
        --outFileNamePrefix ${sample_id}_
    """
}

// Workflow definition
workflow {
    // Load paired-end reads into a channel, automatically extracts sample IDs
    reads_ch = Channel.fromFilePairs('fastq/*_chrX_{1,2}.fastq.gz')
    reads_ch.view()
    // Pass them to the process
    STAR_ALIGN(reads_ch,params.genomeDir,params.gtf)

}

