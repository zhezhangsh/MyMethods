# Alignment and mapping of palindormic PacBio reads

The goal of this procedure is to deal with often palindromic and chimeric PacBio reads by first doing subtraction and then addition:

  - Split each original reads into smaller and overlapping subreads with fixed length
  - Align subreads to reference genome
  - Connect neighboring subreads
  
  
  {abc}
