# Generic description of ChIP-seq workflow

## Alignment

Reference genome is indexed by the ***novoindex*** function of the [***NovoAlign***](http://www.novocraft.com/products/novoalign) package. The sequencing reads in ***.fastq*** files are aligned to the reference genome using the ***novoalign*** function. Aligned reads are stored in ***.sam*** files, which are then converted to sorted and indexed ***.bam*** files using the ***samtools***. 

## Quality control

Quality of aligned reads will be evaluated by one or multiple tools listed below and filtered by ***SAM*** fields, such as _mapq_, _cigar_, and _flag_. Reads with low sequencing or alignment quality will be removed, and libraries with overall low quality will be individually reviewed to decide an action.

  - The publicly available tool **[FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)** to summarize quality score, read length, GC content, duplication level, etc.
  - Our **[bamchop](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-14-S11-S3)** tool that summarizes both of the sequencing reads themselves and the alignment, such as regional enrichment of sequencing depth along chromosomes (_[example](https://github.com/zhezhangsh/MyMethods/blob/master/examples/chipseq/bamchop_histone.pdf)_), as well as the comparison of multiple ChIP-Qualityseq libraries (_[example](https://github.com/zhezhangsh/MyMethods/blob/master/examples/chipseq/bamchop_multi.pdf)_). 

## Calculate base-level sequencing depth

All loaded and filtered reads are extended to 200bp long from their end, and converted to sequencing depth at each base, using the ***[coverage {GenomicRanges}](http://web.mit.edu/~r/current/arch/i386_linux26/lib/R/library/GenomicRanges/html/coverage-methods.html)*** function. The base-level sequencing depth is saved as both R object and ***.bedGraph*** file, which can be visualized with ***UCSC Genome Browser***.
