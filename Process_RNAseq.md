# Processing of RNA-seq data using a customized workflow

## Description

RNA-seq data in .fastq files were aligned to reference genome and transcriptome using the [STAR](https://github.com/alexdobin/STAR)
(Spliced Transcripts Alignment to a Reference) program. STAR was run in the 2-pass mode. The first pass mapped reads to known splice 
junctions in reference transcriptome during alignment while allowing for detection of novel junction sites. Junction sites detected 
from multiple samples by the first pass were collected, combined and filtered. The second pass re-aligned reads to the reference genome
and transcriptome, plus novel junction sites detected by the first pass. The alignment results were saved as indexed .bnam files.

Aligned reads in .bam files were loaded into R using two custom functions.The first function ([link](https://raw.githubusercontent.com/zhezhangsh/Rnaseq/master/examples/LoadBam/LoadBamScript.yml)) maps each aligned reads to known exons, transcripts, and genes. The second function ([link](https://raw.githubusercontent.com/zhezhangsh/Rnaseq/master/R/CountRead.R)) counts number of reads mapped to each gene in multiple categories. It first counts reads mapped to one and only one genes, and then reads mapped to multiple genes. If the libaries were made strand-specific, it will also count the number of reads mapped to the antisense strand of any genes. If the reads were paired, it will also count the number of reads with only one end mapped. Therefore, there are up to 8 categories ofread counts, (unique/sense/paired, multiple/antisense/unpaired, etc.). These categories have different priorities and are mutually exclusive of each other. By default, reads with both ends mapped to the sense strand were counted first, followed by those with both ends mapped to the antisense strand, then by reads with only one end mapped. The count of unique/sense/paired reads is usually the final output for analysis. Finally, gene-level read counts were converted to FPKM (fragment per kilobase per million reads) to represent gene expression level. 

## Step by step

