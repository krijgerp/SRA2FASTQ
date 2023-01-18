#!/bin/bash

## This script download SRA files from NCBI and convert them to fastq
## The script requires a list of SRR IDs (SRR_ID.tsv) and a conda environment (SRA) with the SRA toolkit and pigz installed.
## conda install -c bioconda sra-tools
## conda install -c conda-forge pigz

## Activate conda environment
conda activate SRA

## Create a directory to store SRA files
mkdir ./SRA_download

## Loop over the SRR IDs
for s in $(cat SRR_ID.tsv | sed 's/\t/,/g' | grep "SRA" -v)
do 
## Extract the name and ID from the list
name=$(echo $s | cut -d "," -f 1)
ID=$(echo $s | cut -d "," -f 2)

echo -e "id\t$ID ======================" 2>&1 | tee -a SRRdump.log \
&& prefetch $ID --max-size 100G -O ./SRA_download/ 2>&1 | tee -a SRRdump.log \
&& vdb-validate ./SRA_download/$ID  2>&1 | tee -a SRRdump.log \
&& fasterq-dump ./SRA_download/$ID --outdir ./fastq/ --threads 8 --progress  | tee -a SRRdump.log  \
&& echo "Compressing sample $ID" \
&& pigz -c -p 8 ./fastq/$ID.fastq > ./fastq/$name.$ID.fastq.gz \
&& rm -R ./fastq/$ID.fastq \
&& rm -R ./SRA_download/$ID
done
