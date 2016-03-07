# Processing of RNA-seq data using a customized workflow

## Description

RNA-seq data in .fastq files were aligned to reference genome and transcriptome using the [STAR](https://github.com/alexdobin/STAR)
(Spliced Transcripts Alignment to a Reference) program. STAR was run in the 2-pass mode. The first pass mapped reads to known splice 
junctions in reference transcriptome during alignment while allowing for detection of novel junction sites. Junction sites detected 
from multiple samples by the first pass were collected, combined and filtered. The second pass re-aligned reads to the reference genome
and transcriptome, plus novel junction sites detected by the first pass. The alignment results were saved as indexed .bnam files.

Aligned reads in .bam files were loaded into R using two custom functions.The first function ([link](https://raw.githubusercontent.com/zhezhangsh/Rnaseq/master/examples/LoadBam/LoadBamScript.yml)) maps each aligned reads to known exons, transcripts, and genes. The second function ([link](https://raw.githubusercontent.com/zhezhangsh/Rnaseq/master/R/CountRead.R)) counts number of reads mapped to each gene in multiple categories. It first counts reads mapped to one and only one genes, and then reads mapped to multiple genes. If the libaries were made strand-specific, it will also count the number of reads mapped to the antisense strand of any genes. If the reads were paired, it will also count the number of reads with only one end mapped. Therefore, there are up to 8 categories ofread counts, (unique/sense/paired, multiple/antisense/unpaired, etc.). These categories have different priorities and are mutually exclusive of each other. By default, reads with both ends mapped to the sense strand were counted first, followed by those with both ends mapped to the antisense strand, then by reads with only one end mapped. The count of unique/sense/paired reads is usually the final output for analysis. Finally, gene-level read counts were converted to FPKM (fragment per kilobase per million reads) to represent gene expression level. 

## Step by step

### Prepare reference genome and transcriptome for STAR alignment
  - Download newest version of STAR from https://github.com/alexdobin/STAR
  - Download reference genome (.fasta file) and transcriptome (.gtf/.gff file) from one of the following sources:
   - iGenome: https://support.illumina.com/sequencing/sequencing_software/igenome.html
   - NCBI Genome: http://www.ncbi.nlm.nih.gov/genome/51 (need to map chromosome names if download directly from NCBI)
   - ENSEMBL: http://useast.ensembl.org/info/data/ftp/index.html?redirect=no
  - Generate genome index for STAR without using any annotation ([example code](examples/IndexStarReference.sh))

### Aligne reads to references
 - Locate the full path of all fastq files
 - Download the yaml example from https://raw.githubusercontent.com/zhezhangsh/Rnaseq/master/examples/RunStar/RunStar.yml
 - Edit the yaml file for each data set, especially the following fields:
   - _output_: location of output files
   - _junction_: options about novel junction sites
   - _qsub_: options to **qsub** alignment jobs to a cluster
   - _genomeDir_: directory of indexed reference genome
   - _sjdbGTFfile_: full path to gene annotation gtf file
   - _fastq_: full path of fastq files
 - Rnaseq::RunStar(fn.yaml) to generate code to perfrom STAR alignment for each pass
   - A _RunStar.sh_ file for each sample ([example](examples/RunStar_Pass1.sh))
   - A _qsub.sh_ file for qsub-ing all RunStar.sh files ([example](examples/qsub_STAR.sh))
   - Extra script that delete temporary SAM files and merge junction sites
 - Run STAR
   - Submit the _<PATH>/pass_1/qsub.sh_ file to the cluster for the first pass
   - Run the _<PATH>/pass_1/script/combine_junction.r_ script to combine novel junction sites for the second pass
   - Submit the _<PATH>/pass_2/qsub.sh_ file to the cluster for the second pass
   - Run the _<PATH>/pass_1/script/delete_sam.sh_ script to remove temparary sam files
 - The final output is a set of sorted and indexed .bam files

### Count reads mapped to annotated genes


  
