


process STAR_INDEX {

	publishDir "INDEX", mode:'copy'
	
	input:
		path(fasta)
		path(gtf)
	output:
		path "*", emit: index
	
	script:
		"""
		STAR --runThreadN 8 \\
		--runMode genomeGenerate \\
		--genomeDir index \\
		--genomeFastaFiles ${fasta} \\
		--sjdbGTFfile ${gtf} \\
		--genomeSAindexNbases 12 \\
	"""

}

workflow {
	
	ref_fasta=Channel.fromPath(params.ref_fasta)
	ref_gtf=Channel.fromPath(params.ref_gtf)

	STAR_INDEX(ref_fasta, ref_gtf).set{star_index}
}
