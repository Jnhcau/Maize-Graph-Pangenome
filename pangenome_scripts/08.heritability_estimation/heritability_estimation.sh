plink --vcf All_imputated.vcf --make-bed --out 368sv
ldak6.2.linux --cut-weights weights --bfile 368sv --max-threads 100
ldak6.2.linux --calc-weights-all weights   --bfile 368sv --max-threads 100

ldak6.2.linux --calc-kins-direct kinship \
  --bfile 368sv \
  --weights weights/weights.all \
  --power -0.5 \
  --max-threads 100

plink --allow-extra-chr --threads 20 -bfile 368sv --pca 3  --out 368sv.plink.pca


ldak6.2.linux --reml  368sv --pheno pheno_renamed.txt --grm kinship --covar 368sv.plink.pca.eigenvec --constrain YES
