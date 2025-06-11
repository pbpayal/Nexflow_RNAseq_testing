
//params.reads = "/data/NHGRImito/Payal/Nexflow_test/test_proj/fastq/*fastq.gz" 

process FASTQC {
	tag "Running FastQC on ${sampleid}"
	
	publishDir "QC_Report",mode: 'copy'

	input:
		tuple val(sampleid), path(reads)
	
	output:
		path "*"
	script:
		"""
		fastqc ${reads} 
		//multiqc *fastqc*
		"""

}




workflow {

// Load reference files
ref_fasta=Channel.fromPath(params.ref_fasta)
ref_gtf=Channel.fromPath(params.ref_gtf)

// Load paired-end reads
fasta_ch=Channel.fromFilePairs(params.reads)

// Strand information
strand=Channel.of(params.strand)

//ref_fasta.view()
//ref_gtf.view()
//strand.view()
fasta_ch.view()


// Running FASTQC on the paired-end reads
FASTQC(fasta_ch).set{QCed}


}

