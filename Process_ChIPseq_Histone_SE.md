# Processing of single-ended ChIP-seq data of histone modifications

## Alignment of sequencing reads

Reference genome is indexed by the ***novoindex*** function of the [***NovoAlign***](http://www.novocraft.com/products/novoalign) package. The sequencing reads stored in ***.fastq*** files are aligned to the reference genome using the ***novoalign*** function. Aligned reads are stored in ***.sam*** files, which are then converted to sorted and indexed ***.bam*** files using the ***samtools***. 

## Load aligned reads into R

Aligned reads are loaded into R using the [***readGAlignments {GenomicAlignments}***](http://rpackages.ianhowson.com/bioc/GenomicAlignments/man/readGAlignments.html) function. Loaded reads are filtered by ***SAM*** fields such as _mapq_, _cigar_, and _flag_, using [this](https://raw.githubusercontent.com/zhezhangsh/RoCA/master/template/qc/filter_read/filter_read.Rmd) ***RoCA*** template. The template will also generate a formatted report to summarize these statistics. 

## Calculate base-level sequencing depth

All loaded and filtered reads are extended to 200bp long from their end, and converted to sequencing depth at each base, using the ***coverage {GenomicRanges}*** function. The base-level sequencing depth is saved as both R object and ***.bedGraph*** file, which can be visualized with UCSC Genome Browser.
