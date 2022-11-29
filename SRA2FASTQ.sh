#conda create -n SRA -c bioconda sra-tools
conda activate SRA
mkdir ./SRA_download
for s in $(cat SRR_ID.tsv | sed 's/\t/,/g' | grep "SRA" -v)
do 
name=$(echo $s | cut -d "," -f 1)
ID=$(echo $s | cut -d "," -f 2)
echo -e "id\t$ID ======================" 2>&1 | tee -a SRRdump.log \
&& prefetch $ID --max-size 100G -O ./SRA_download/ 2>&1 | tee -a SRRdump.log \
&& vdb-validate ./SRA_download/$ID  2>&1 | tee -a SRRdump.log \
&& fasterq-dump ./SRA_download/$ID --outdir ./fastq/ --threads 8 --progress  | tee -a SRRdump.log  \
&& pigz -c -p 8 ./fastq/$ID.fastq > ./fastq/$name_$ID.fastq.gz \
&& rm -R ./fastq/$ID.fastq
done
rm -R ./SRA_download
