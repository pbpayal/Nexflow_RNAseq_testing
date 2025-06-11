#!/usr/bin/env nextflow

nextflow.enable.dsl=2

// Define parameters
params.reads = 'fastq/*.gz'  // Default value if not provided

// Check required input
if (!params.reads) {
    error "Missing required parameter: --reads"
}

// Define process
process FASTQC {
    tag "FastQC on ${sampleid}"

    publishDir "QC_Report", mode: 'copy'
    
    module 'fastqc' 

    input:
    tuple val(sampleid), path(read)

    output:
    path "*"

    script:
    """
    fastqc ${read}
    """
}

// Define workflow
workflow {
    reads_ch = Channel
        .fromPath(params.reads, checkIfExists: true)
        .map { file -> tuple(file.baseName, file) }

    FASTQC(reads_ch)
}

