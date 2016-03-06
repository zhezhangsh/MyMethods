############
# C2865
/mnt/isilon/cbmi/variome/rnaseq_workspace/tools/STAR-2.5.1b/bin/Linux_x86_64_static/STAR \
--readFilesIn /mnt/isilon/cbmi/variome/zhangz/projects/simmons/fastq/C2865_1.fq.gz /mnt/isilon/cbmi/variome/zhangz/projects/simmons/fastq/C2865_2.fq.gz \
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
--outFileNamePrefix /home/zhangz/R/source/MyMethods/examples/rnaseq/star/pass_1/C2865_


