# Alignment and mapping of palindromic PacBio reads

The goal of this procedure is to deal with often palindromic and chimeric PacBio reads by first doing subtraction and then addition:

  - Split each original reads into smaller and overlapping subreads with fixed length.
  - Align subreads to reference genome.
  - Connect neighboring subreads mapped to the same loci on reference genome, to obtain full length alignment of subreads. 
  - Take consensus from aligned subreads in the same original reads that are palindromic to each other.
  
It is expected that this procedure will improve the detection of palindrome in PacBio reads and reduce error rate in the consensus of palindromic subreads.

## Split reads

This is a subtraction step that splits long reads into smaller subreads with fixed length. By default, the subreads are overlapped to each other to improve overall coverage. 

In the example below, 

  - Prepare 3 character vectors of original read IDs, read sequences, and quality scores, all with the same length and matching each other
  - Obtain the 1st subread from 1-400 from the original read, then the 2nd from 101-500 (100bp step size), until the end of the original read
  - Remove subreads shorter than 200bp
  - Name each subreads following the [QNAME convention](https://pacbiofileformats.readthedocs.io/en/3.0/BAM.html#qname-convention) of unrolled PacBio read
  - Write all subreads to a .fastq file

```r
## Example R code

# devtools::install_github('zhezhangsh/RH');
require(RH);

# id, seq and qual are character vectors of the same length with read IDs, sequences, quality scores
TrimLongRead(id=id, seq=seq, qual=qual, length=400, step=100, min.length=200,
            output='fastq', filename='trimmed400.fastq');
```

## Align reads

The subreads are aligned to reference genome, or targeted regions like RH genes, using [blasr](https://github.com/PacificBiosciences/blasr). 

In the example below: 

  - Use the output file from the last step <trimmed.fastq>
  
  
```sh
blasr trimmed400.fastq target12.fasta --sam --placeGapConsistently --out trimmed400.sam --nproc 32 --hitPolicy all --minAlnLength 200

```
