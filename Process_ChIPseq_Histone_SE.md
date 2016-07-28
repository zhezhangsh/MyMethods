# Processing of single-ended ChIP-seq data of histone modifications

## Alignment of sequencing reads

Reference genome is indexed by the ***novoindex*** function of the ***NovoAlign*** package. The sequencing reads stored in ***.fastq*** files are aligned to the reference genome using the ***novoalign*** function. Aligned reads are stored in ***.sam*** files, which are then converted to sorted and indexed ***.bam*** files using the ***samtools***. 

## 
