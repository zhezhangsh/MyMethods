# Processing of single-ended ChIP-seq data of histone modifications

## Alignment of sequencing reads

Reference genome is indexed by the _novoindex_ function of the _NovoAlign_ package. The sequencing reads stored in _.fastq_ files are aligned to the reference genome using the _novoalign_ function. Aligned reads are stored in _.sam_ files, which are then converted to sorted and indexed _.bam_ files using the _samtools_. 

## 
