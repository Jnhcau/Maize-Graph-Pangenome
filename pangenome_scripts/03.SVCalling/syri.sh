#!/bin/sh
cat $query.mcoords|sed '1,4d'|cut -f 1-7,12-15 >$query.mcoords.syri

syri --nc 10  --nosnp --prefix $query. -c $query.mcoords.syri -d $query.mdelta -r ref.fa -q $query.ordered.qry.fasta
