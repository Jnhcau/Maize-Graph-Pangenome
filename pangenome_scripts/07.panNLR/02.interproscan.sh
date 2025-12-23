interproscan.sh \  -i pep.fasta \ -cpu 2 \
  -iprlookup \
  -goterms \
  -f tsv -f gff3 \
  -dp -pa -dra \
  -b ./genes_out
