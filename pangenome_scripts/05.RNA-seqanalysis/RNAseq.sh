mkdir -p 01.fastp

for r1 in 00.rawfastq/*_R1.fq.gz; do
    r2=${r1/_R1.fq.gz/_R2.fq.gz}

    sample=$(basename $r1 _R1.fq.gz)

    fastp \
        -i $r1 \
        -I $r2 \
        -o 01.fastp/${sample}_clean_R1.fq.gz \
        -O 01.fastp/${sample}_clean_R2.fq.gz \
        -h 01.fastp/${sample}.html \
        -w 16
done

##################################
mkdir -p 02.alignhisat2
for r1 in 01.fastp/LP_B104_root1_clean_R1.fq.gz; do
    r2=${r1/_clean_R1.fq.gz/_clean_R2.fq.gz}
    sample=$(basename "$r1" _clean_R1.fq.gz)

    hisat2 --new-summary -p 50 -x /home/jianianhua/B73V5/B73V5GDB -1 "$r1" -2 "$r2" \
        2> 02.alignhisat2/${sample}.hisat2.log | \
    samtools view -bS - | \
    samtools sort -@ 50 -o 02.alignhisat2/${sample}.bam -

    samtools index 02.alignhisat2/${sample}.bam
done

##################################
cd 02.alignhisat2
featureCounts \
    -T 30 \
    -p \
    -t exon \
    -g gene_id \
    --countReadPairs \
    -a /home/Maize_reference/B73-REFERENCE-NAM-5.0.52/Zea_mays.Zm-B73-REFERENCE-NAM-5.0.52.gtf \
    -o gene_counts.txt \
    *.bam

featureCounts \
    -T 30 \
    -p \
    -t exon \
    -g transcript_id \
    --countReadPairs \
    -a /home/Maize_reference/B73-REFERENCE-NAM-5.0.52/Zea_mays.Zm-B73-REFERENCE-NAM-5.0.52.gtf \
    -o transcripts_counts.txt \
    *.bam

tail -n +2 gene_counts.txt | cut -f1,7- > genes.counts.matrix
tail -n +2 transcript_counts.txt | cut -f1,7- > transcripts.counts.matrix

