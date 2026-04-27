plink --vcf 368sv.fakeALT.vcf.gz --make-bed --out 368sv
ldak6.2.linux --cut-weights weights --bfile 368sv --max-threads 100
ldak6.2.linux --calc-weights-all weights   --bfile 368sv --max-threads 100

ldak6.2.linux --calc-kins-direct kinship \
  --bfile 368sv \
  --weights weights/weights.all \
  --power -0.5 \
  --max-threads 100
