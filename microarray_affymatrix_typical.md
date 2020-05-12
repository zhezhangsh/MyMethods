# Typical way to process a set of Affymetrix microarrays

All [Affymetrix](http://www.affymetrix.com) probes were re-grouped into unique Entrez gene IDs using custom library file downloaded from [BRAINARRAY](http://brainarray.mbni.med.umich.edu) database. The raw data in .CEL files were normalized and summarized by [RMA](http://www.ncbi.nlm.nih.gov/pubmed/12925520) (Robust Multichip Averaging) method to generate an N by M matrix, where N is the number of unique Entrez genes and M is the number of samples. The normalized data were log2-transformed to get final measurements mostly ranging between 1 and 16, so every increase or decrease of the measurements by 1.0 corresponds to a 2-fold difference. All data processing steps were performed within the [R](https://www.r-project.org) environment. The following customized code can be applied to any types of [Affymetrix](http://www.affymetrix.com/estore/browse/level_three_category_and_children.jsp?category=35868&categoryIdClicked=35868&expand=true&parent=35617) platforms (3'IVT, Exon, Gene, etc.) as long as the raw data were stored in [CEL](http://media.affymetrix.com/support/developer/powertools/changelog/gcos-agcc/cel.html) format and [BRAINARRAY](http://brainarray.mbni.med.umich.edu/Brainarray/Database/CustomCDF/CDF_download.asp) provides the custom library file in CDF format.

```
# fn.cel: names of all .CEL files with raw data

```
# Install and load the library
library(devtools);
install_github("zhezhangsh/rchive");
library(rchive);
```

# Download

# Load and process
raw<-LoadAffyCel(fn.cel); # Load the CEL files into R
raw@cdfName<-InstallBrainarray(raw@cdfName); # Install the BRAINARRAY custom library and rename the library name
expr<-exprs(rma(raw)); # Load and process the data to generate a N by M matrix

# Optionally, rename gene and sample IDs
expr<-expr[grep('_at$', rownames(expr)), , drop=FALSE];
rownames(expr)<-sub('_at$', '', rownames(expr));
cnm<-sub('.CEL.gz$', '', sampleNames(raw));
cnm<-sapply(strsplit(cnm, '/'), function(x) x[length(x)]);
colnames(expr)<-cnm;
```
