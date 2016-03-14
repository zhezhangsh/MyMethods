# Processing of RNA-seq data using a customized workflow

## Description

RNA-seq data in .fastq files were aligned to reference genome and transcriptome using the [STAR](https://github.com/alexdobin/STAR)
(Spliced Transcripts Alignment to a Reference) program. STAR was run in the 2-pass mode. The first pass mapped reads to known splice 
junctions in reference transcriptome during alignment while allowing for detection of novel junction sites. Junction sites detected 
from multiple samples by the first pass were collected, combined and filtered. The second pass re-aligned reads to the reference genome
and transcriptome, plus novel junction sites detected by the first pass. The alignment results were saved as indexed .bnam files.

Aligned reads in .bam files were loaded into R using two custom functions.The first function ([link](https://raw.githubusercontent.com/zhezhangsh/Rnaseq/master/examples/LoadBam/LoadBamScript.yml)) maps each aligned reads to known exons, transcripts, and genes. The second function ([link](https://raw.githubusercontent.com/zhezhangsh/Rnaseq/master/R/CountRead.R)) counts number of reads mapped to each gene in multiple categories. It first counts reads mapped to one and only one genes, and then reads mapped to multiple genes. If the libaries were made strand-specific, it will also count the number of reads mapped to the antisense strand of any genes. If the reads were paired, it will also count the number of reads with only one end mapped. Therefore, there are up to 8 categories ofread counts, (unique/sense/paired, multiple/antisense/unpaired, etc.). These categories have different priorities and are mutually exclusive of each other. By default, reads with both ends mapped to the sense strand were counted first, followed by those with both ends mapped to the antisense strand, then by reads with only one end mapped. The count of unique/sense/paired reads is usually the final output for analysis. Finally, gene-level read counts were converted to FPKM (fragment per kilobase per million reads) to represent gene expression level. 

## Step by step

### Prepare reference genome and transcriptome for STAR alignment: 
1. Download newest version of STAR from https://github.com/alexdobin/STAR
2. Download reference genome (.fasta file) and transcriptome (.gtf/.gff file) from one of the following sources:
   - iGenome: https://support.illumina.com/sequencing/sequencing_software/igenome.html
   - NCBI Genome: http://www.ncbi.nlm.nih.gov/genome/51 (need to map chromosome names if download directly from NCBI)
   - ENSEMBL: http://useast.ensembl.org/info/data/ftp/index.html?redirect=no
3. Generate genome index for STAR without using any annotation (example: https://raw.githubusercontent.com/zhezhangsh/MyMethods/master/examples/rnaseq/star/generate_ref.sh)

```
# Generate reference genome
/nas/is1/rnaseq_workspace/tools/STAR-2.5.1b/bin/Linux_x86_64_static/STAR \
--runThreadN 12 \
--runMode genomeGenerate \
--genomeDir /nas/is1/rnaseq_workspace/refs/mm38/star \
--genomeFastaFiles /nas/is1/rnaseq_workspace/refs/mm38/GCF_000001635.24_GRCm38.p4_genomic.fna
```

### Align reads to references via STAR
1. Locate the full path of all fastq files
2. Download the yaml template to local fold 

```
# Download yaml template
wget https://raw.githubusercontent.com/zhezhangsh/Rnaseq/master/examples/RunStar/RunStar.yml RunStar.yml
```

3. Edit the yaml file for each data set, especially the following fields

# yaml fields
output: /home/zhangz/R/source/MyMethods/examples/rnaseq/star  # location of output files
junction:                                                     # options about combining novel junction sites from individual libraries
  combine: yes                                                  # combine junction sites ?
  filename: combined_SJ.out.tab                                 # file name of combined junctions
  canonical: no                                                 # include canonical sites only in the combined file?
  unannotated: yes                                              # include unannotated sites only in the combined file?
  minimum:                                                      # filtering strategies
    read: 3                                                       # the minimal number of reads mapped to the jucntion in each library
    overhang: 5                                                   # the minimal overhang of the junction in each library
    sample: 3                                                     # the minimal number of samples meeting the last 2 criteria
    total: 12                                                     # the total number of reads from all libraries mapped to the junction
qsub:                                                         # options to qsub alignment jobs to a cluster
  will: yes                                                     # will qsub jobs?
  prefix: qsub -cwd -l mem_free=32G -l h_vmem=64G -pe smp 16    # command prefix for qsub each alignment jobs
  path:                                                         # path change
    from: /nas/is1                                                # local path to the input files      
    to: /mnt/isilon/cbmi/variome                                  # cluster path for qsub
options:                                                      # other options
   - _genomeDir_:                                               # directory of indexed reference genome
   - _sjdbGTFfile_:                                             # full path to gene annotation gtf file   
fastq:                                                        # list of fastq files, name each library
  C2863:                                                        # name of library
    fastq1: /nas/is1/zhangz/projects/simmons/fastq/C2863_1.fq.gz
    fastq2: /nas/is1/zhangz/projects/simmons/fastq/C2863_2.fq.gz
```

 - Rnaseq::RunStar(fn.yaml) to generate code to perfrom STAR alignment for each pass
   - A _RunStar.sh_ file for each sample ([example](examples/rnaseq/star/pass_1/STAR_C2863.sh))
   - A _qsub.sh_ file for qsub-ing all RunStar.sh files ([example](examples/rnaseq/star/pass_1/qsub.sh))
   - Extra script that delete temporary SAM files and merge junction sites ([example](examples/rnaseq/star/pass_1/script))
 - Run STAR
   - Submit the _<PATH>/pass_1/qsub.sh_ file to the cluster for the first pass
   - Run the _<PATH>/pass_1/script/combine_junction.r_ script to combine novel junction sites for the second pass
   - Submit the _<PATH>/pass_2/qsub.sh_ file to the cluster for the second pass
   - Run the _<PATH>/pass_1/script/delete_sam.sh_ script to remove temparary sam files
 - The final output is a set of sorted and indexed .bam files

### Count reads mapped to annotated genes


  
