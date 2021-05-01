
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
  - The gene-cell matrix is filtered to remove barcodes (cells) with low total counts (default=500)
  - The filtered gene-cell matrices of multiple libraries are aggregated to generate a single gene-cell matrix for the whole data set

## Cell clustering by Seurat

**Seurat** is an R package of scRNA-seq analysis tools. The Cell Ranger outputs, including filtered gene-cell read count matrix and metadata, are loaded into R to create a Seurat object for further data processing and analysis as below.

### A single scRNA-seq library

The following steps are applied to each individual library after its Cell Ranger outputs are loaded into R. (Check individual analysis reports to find the values of unspecified parameters).

  - Filter genes to remove those detected in fewer than ***X*** cells
  - Filter cells to remove those with fewer than ***X*** or more than ***Y*** detected genes
  - Filter cells to remove those with more than ***X***% of total read count contributed by mitochondrial genes
  - (Optional) filter cells to remove those with more than ***X***% of total read count contributed by immunoglobin genes
  - Normalize the read count data between cells, using the ***LogNormalize*** method (divided by total count of the cell, multiplied by a constant scaling factor, and then natural-log transformation)
  - Scale the LogNormalized data of each gene across all cells to make its mean equal to 0 and standard deviation equal to 1. 
  - Run principal components analysis (PCA) on genes to reduce data dimensionality with 50 initial principal components
  - Run the Jack Straw

```
# Code example to analyze a signle scRNA-seq library using Seurat
cnt <- Read10X('path/sample_id/outs/filtered_feature_bc_matrix');  # read in gene-cell read count matrix

srt <- CreateSeuratObject(cnt, project=nm, min.cells = 3, min.features = 200));
saveRDS(srt, 'seurat.rds'); # 0
for (i in 1:length(srt)) srt[[i]][["percent.mt"]] <- PercentageFeatureSet(srt[[i]], pattern = "^mt-");
for (i in 1:length(srt)) srt[[i]][["percent.ig"]] <- PercentageFeatureSet(srt[[i]], pattern = "^Ig");
srt <- lapply(srt, function(s) subset(s, subset = nFeature_RNA >= 200 & nFeature_RNA <= 6000 & percent.mt < 5 & percent.ig < 15));
saveRDS(srt, 'seurat_subset.rds'); # 1
srt <- lapply(srt, NormalizeData);
saveRDS(srt, 'seurat_normalized.rds'); # 2
srt <- lapply(srt, FindVariableFeatures);
saveRDS(srt, 'seurat_highvar.rds'); # 2
srt <- lapply(srt, ScaleData);
saveRDS(srt, 'seurat_scaled.rds'); # 4
srt <- lapply(srt, RunPCA);
saveRDS(srt, 'seurat_pca.rds'); # 5
srt <- lapply(srt, JackStraw);
srt <- lapply(srt, function(s) ScoreJackStraw(s, dims=1:20));
saveRDS(srt, 'seurat_jackstraw.rds'); # 6
jck <- lapply(srt, function(s) s@reductions$pca@jackstraw@overall.p.values);
jck <- sapply(jck, function(j) max(j[j[, 2]<=10^-5, 1]));
srt <- lapply(1:length(srt), function(i) FindNeighbors(srt[[i]], dims=1:jck[i]));
srt <- lapply(srt, function(s) FindClusters(s, resolution = 0.8));
saveRDS(srt, 'seurat_clustered.rds'); # 7
srt <- lapply(1:length(srt), function(i) RunTSNE(srt[[i]], dims=1:jck[i]));
saveRDS(srt, 'seurat_tsne.rds'); # 8
srt <- lapply(1:length(srt), function(i) RunUMAP(srt[[i]], dims=1:jck[i]));
saveRDS(srt, 'seurat_umap.rds'); # 9



```

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

