# SRA2FASTQ
Bash script to download SRA data and save as compressed fastq files. 

This script will use [SRA-tools](https://github.com/ncbi/sra-tools/wiki/HowTo:-fasterq-dump) to download SRA data based on the accession number in SRR_ID.tsv. After validation it will convert the SRA data into a fastq file. Pigz is used to compresed the fastq file.

This requires sra-tools and pigz to be installed.
SRA-tools:
conda create -n sra -c bioconda sra-tools

Pigz:
conda install -c conda-forge pigz
or install it globally
apt-get install pigz -y


alternatively just download the fastq files directly from ENA.
You can use https://sra-explorer.info to automatically get the download scripts.
