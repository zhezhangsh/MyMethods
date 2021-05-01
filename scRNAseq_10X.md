
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

### Analysis of each single library

The following steps are applied to each scRNA-seq library after its raw data is processed by Cell Ranger as described above. (Check individual analysis reports to find the values of unspecified parameters).

  - Filter genes to remove those detected in fewer than ***X*** cells
  - Filter cells to remove those with fewer than ***X*** or more than ***Y*** detected genes
  - Filter cells to remove those with more than ***X***% of total read count contributed by mitochondrial genes
  - (Optional) filter cells to remove those with more than ***X***% of total read count contributed by immunoglobin genes
  - Normalize the read count data between cells, using the ***LogNormalize*** method (divided by total count of the cell, multiplied by a constant scaling factor, and then natural-log transformation)
  - Scale the LogNormalized data of each gene across all cells to make its mean equal to 0 and standard deviation equal to 1. 
  - Select top ***X*** high variable genes to reduce computational burden
  - Run principal components analysis (PCA) on genes to reduce data dimensionality with 50 initial principal components
  - Run the Jack Straw procedure to determine the number of dimensions for cell clustering analysis with default p value cutoff equal to 1e-5
  - Cluster cells using the number of dimensions determined by Jack Straw and the Shared Nearest Neighbor (SNN) algorithm, with default resolution equal to 0.8
  - Run both t-SNE and UMAP algorithms to project the cell clusters on a 2-dimensional space
  - Use Wilcoxon Rank Sum test to identify marker genes of each cluster by comparing it to all other cells

```
# Example code to analyze a signle scRNA-seq library using Seurat
cnt <- Read10X('path/sample_id/outs/filtered_feature_bc_matrix');  # read in gene-cell read count matrix
srt <- CreateSeuratObject(cnt, project='myProject', min.cells = 3);
srt[["percent.mt"]] <- PercentageFeatureSet(srt, pattern = "^mt-");
srt[["percent.ig"]] <- PercentageFeatureSet(srt, pattern = "^Ig");
srt <- subset(srt, subset = nFeature_RNA >= 200 & nFeature_RNA <= 6000 & percent.mt < 5);
srt <- NormalizeData(srt);
srt <- ScaleData(srt);
srt <- FindVariableFeatures(srt);
srt <- RunPCA(srt);
srt <- JackStraw(srt);
srt <- ScoreJackStraw(srt);
jck <- srt@reductions$pca@jackstraw@overall.p.values;
jck <- max(jck[jck[, 2]<=10^-5, 1]);
srt <- FindNeighbors(srt, dims=1:jck);
srt <- FindClusters(srt);
srt <- RunTSNE(srt, dims=1:jck);
srt <- RunUMAP(srt, dims=1:jck);

mrk0 <- FindMarkers(srt ident.1=0); # Compare Cluster 0 cells to all other cells to identify Cluster 0 marker
```

## Integrative analysis of multiple libraries

The following steps are applied to a number of scRNA-seq libraries after all libraries are processed by Cell Ranger as described above. Check individual analysis reports to find the values of unspecified parameters.

Seurat provides 2 options of integrating multiple libraries. Check project-specific analysis to find out which one was used.

**Standard integration**

This method is preferred when systematic bias or batch effect between libraries is not substantial. Normalization of read count matrix and selection of high variance genes are applied to individual libraries before the integration. The integration first identifies pairs of cells in different libraries as anchors, which are in the same biological state and could be found in all libraries. The anchors are then utilized as reference to transform the data of all libraries so they can be analyzed together.

```
# Example code to integrate a list of Seurat object (scRNA-seq libraries) by standard procedure
srt <- lapply(srt, NormalizeData); # Normalize a list of Seurat objects
srt <- lapply(srt, FindVariableFeatures);
srt <- FindIntegrationAnchors(object.list = srt);
srt <- IntegrateData(anchorset = srt);
srt <- ScaleData(srt);
```

**SCTransform**


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

