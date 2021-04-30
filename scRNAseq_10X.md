
# Introduction

The document describes the generic data processing and analysis steps applied to the scRNA-seq data as below:

  - ThescRNA-seq data set is generated using the 10x Genomics Chromium technology
  - The data set includes 2 or more treatment groups and the main analysis goal is the differential gene expression between groups
  - Each treatment group includes 2 or more replicates (individual scRNA-seq libraries) 

# Data processing and analysis

## Raw data processing by Cell Ranger

By default, the Cell Ranger pipeline is used to

  - Demultiplex the raw sequencing data in BCL (base call) file into FASTQ files of individual scRNA-seq libraries
  - Align sequencing reads to reference transcriptome (GRCh38, GRCm38, etc.)
  - Aligned to reads are mapped to genes and split by their barcodes to generate a feature-barcode (gene-cell) read count matrix
  - The read count matrix is filtered to remove barcodes (cells) with low total counts (default=500)
  - The filtered read count matrices of multiple libraries are aggregated to generate a single gene-cell matrix for the whole data set

## 


# References

  - [Cell Ranger](https://support.10xgenomics.com/single-cell-gene-expression/software/overview/welcome)
  - [Seurat](https://satijalab.org/seurat/)
  - [Current best practices](https://www.embopress.org/doi/full/10.15252/msb.20188746)
  - [Experimental design](https://academic.oup.com/bfg/article/17/4/233/4604806)
  - [Granatum: graphical pipeline](https://genomemedicine.biomedcentral.com/articles/10.1186/s13073-017-0492-3)
  - [scPipe: Bioconductor preprocessing pipeline](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1006361)
  - [Compare clustering tools](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6124389.2)
  - [Workflow via Wei Sun](http://research.fhcrc.org/content/dam/stripe/sun/software/scRNAseq/scRNAseq.html)
  - [Analyze with DESeq2](http://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html)
  - [Monocle 3](https://cole-trapnell-lab.github.io/monocle3/)

