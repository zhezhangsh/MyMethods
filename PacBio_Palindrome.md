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


```r
ls()
```

