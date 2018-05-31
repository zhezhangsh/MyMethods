# Generic description of ChIP-seq workflow

## Alignment

Reference genome is indexed by the ***novoindex*** function of the [***NovoAlign***](http://www.novocraft.com/products/novoalign) package. The sequencing reads in ***.fastq*** files are aligned to the reference genome using the ***novoalign*** function. Aligned reads are stored in ***.sam*** files, which are then converted to sorted and indexed ***.bam*** files using the ***samtools***. 

## Quality control

Quality of aligned reads will be evaluated by one or multiple tools listed below. Read filtering will be applied based on ***SAM*** fields, such as _mapq_, _cigar_, and _flag_, alignment location, and level of duplication due to PCR bias. Reads with poor sequencing or alignment quality will be removed, and libraries with overall low quality will be individually reviewed to decide an action.  

  - The publicly available tool **[FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)** to summarize quality score, read length, GC content, duplication level, etc.
  - Our **[bamchop](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-14-S11-S3)** tool that summarizes both of the sequencing reads themselves and the alignment, such as regional enrichment of sequencing depth along chromosomes (_[example](https://github.com/zhezhangsh/MyMethods/blob/master/examples/chipseq/bamchop_histone.pdf)_), as well as the comparison of multiple ChIP-Qualityseq libraries (_[example](https://github.com/zhezhangsh/MyMethods/blob/master/examples/chipseq/bamchop_multi.pdf)_). 
  - An Rmarkdown template based on our ***[RoCA](https://github.com/zhezhangsh/RoCA)*** framework that will generate a formatted report (_[example](https://github.com/zhezhangsh/MyMethods/blob/master/examples/chipseq/filter_read.pdf)_) for each ChIP-seq libraries. It simutaneously summarizes read/alignment quality and filter reads by quality, length, location, etc.

## Visualization

Aligned reads are converted to sequencing depth along chromosomes and saved in ***.bedGraph*** format to be visualized via **UCSC Genome Browser**. Single-end reads are extended at the 3' end to the estimated average length of DNA fragments in the ChIP-seq library to cover regions occupied by the target proteins. By default, the reads will be extended to 200bp long when the ChIP-seq targets are histone modifications.


