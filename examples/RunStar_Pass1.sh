# Pass 1 of running STAR alignment

############
# 2867LPS-R1FL
/mnt/isilon/cbmi/variome/rnaseq_workspace/tools/STAR-2.5.1b/bin/Linux_x86_64_static/STAR \
--readFilesIn /mnt/isilon/cbmi/variome/zhangz/projects/simmons/fastq/2867LPS-R1FL_1.fq.gz /mnt/isilon/cbmi/variome/zhangz/projects/simmons/fastq/2867LPS-R1FL_2.fq.gz \
--runThreadN 8 \
--readFilesCommand zcat \
--genomeDir /mnt/isilon/cbmi/variome/rnaseq_workspace/refs/mm38/star \
--sjdbGTFfile /mnt/isilon/cbmi/variome/rnaseq_workspace/refs/mm38/GCF_000001635.24_GRCm38.p4_genomic.gff \
--outSAMtype SAM \
--chimSegmentMin 32 \
--outFilterType BySJout \
--outFilterMultimapNmax 20 \
--alignSJoverhangMin 8 \
--alignSJDBoverhangMin 1 \
--outFilterMismatchNmax 999 \
--outFilterMismatchNoverLmax 0.04 \
--alignIntronMin 20 \
--alignIntronMax 1000000 \
--alignMatesGapMax 1000000 \
--twopassMode None \
--outFileNamePrefix /mnt/isilon/cbmi/variome/zhangz/projects/simmons/2016-02_RNAseq/star/pass_1/2867LPS-R1FL_
