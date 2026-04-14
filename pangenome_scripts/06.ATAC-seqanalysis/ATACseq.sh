bowtie2 --very-sensitive -X 2000 --no-mixed --no-discordant -p 5 -x bowtie2_index -1 sample_R1.clean.fastq.gz -2 sample_R2.clean.fastq.gz  | samtools sort -@ 5 -O bam -o sample.sorted.bam
picard MarkDuplicates REMOVE_DUPLICATES=true I=${bam_file} O=${dedup_bam} M=${metrics_file} && samtools index ${dedup_bam}

#### methods1 macs2 Calling ####
bedtools  bamtobed  -i dedup_bam  -bedpe > dedup.bed
zcat sample.tagAlign.gz | \
awk -F '\t' 'BEGIN {OFS = FS}{ \
  if ($6 == "+") {$2 = $2 + 4} \
  else if ($6 == "-") {$3 = $3 - 5} \
  print $0}' | \
gzip -nc sample.tn5.shift.tagAlign.gz
macs2 callpeak -t sample.dedup.bam -f BAM -g 2.18e9 -n sample --outdir macs2_out --keep-dup all -q 0.05 --nomodel --shift 100 --extsize 200 -B --SPMR -f BAMPE

sort -k8,8nr sample_peaks.narrowPeak > sample_peaks_sorted.narrowPeak #sort by p-value
idr --samples sample_Rep1_sorted_peaks.narrowPeak sample_Rep2_sorted_peaks_sorted.narrowPeak \
    --input-file-type narrowPeak \
    --rank p.value \
    --output-file sample-idr \
    --plot \
    --log-output-file sample.idr.log

#### methods2 Genrich Peak Calling ####
Genrich -t ${sample1}_rep1.bam,${bam_dir}/${sample1}_rep2.bam,${bam_dir}/${sample1}_rep3.bam \
-o ${sample1}.narrowPeak -f ${genrich_dir}/${group}_pq.bed \
-k ${genrich_dir}/${group}_pileup_p.bed -b ${genrich_dir}/${group}_reads.bed \
-E ${rm_bed} -m 30 -q 0.05 -a 500 -r -j
