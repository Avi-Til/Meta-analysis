#!/bin/sh -l

#SBATCH --nodes=1
#SBATCH --tasks-per-node=80
#SBATCH --time=24:00:00
#SBATCH --job-name MetaAnalysis
#SBATCH -A microbiome

###################################################################

echo  "Start time: "
date +"%d %B %Y %H:%M:%S"

cd /scratch/bell/avijiela/Project/Analysis

echo  "Loading Bioinfo module..."
module load bioinfo
echo "Done"

echo  "Loading BLAST module..."
module load blast
echo "Done"

mkdir Blast
mkdir Blast/BlastDB
mkdir Blast/BlastOut

n=0
blastdb="Blast/BlastDB/Blast${n}.db"
blastout="Blast/BlastOut/Blast${n}"
while read accID 
do
 echo "Run number: ${n}, Accession ID: ${accID}"
 if [ ${n} -eq 0 ]
 then
  cp ${accID}/${accID}.fasta ${blastdb}.fasta
 else
  echo  "Blasting..."
  blastn -db ${blastdb} -query ${accID}/${accID}.fasta -out ${blastout}.out -outfmt '7 qseqid sseqid qlen slen length pident qcovs qstart qend sstart send evalue bitscore' -num_threads 80
  echo "Done"
  echo  "Filtering Results..."
  grep -A23 "# Query:" ${blastout}.out > ${blastout}_20.out
  grep "100.000" ${blastout}_20.out > ${blastout}_20-100.out
  awk '$5>240' ${blastout}_20-100.out > ${blastout}_20-100-240.out
  awk 'NR==FNR{a[$1];next} {for(i in a) if($0 ~ i){getline;next}}1' ${blastout}_20-100-240.out ${accID}/${accID}.fasta > ${blastout}_tomerge.fasta
  echo "Done"
  echo  "Merging FASTA..."
  cat ${blastdb}.fasta ${blastout}_tomerge.fasta > Blast/BlastDB/Blast${n}.db.fasta
  echo "Done"
 fi
 blastdb="Blast/BlastDB/Blast${n}.db"
 echo "Making Blast Database..."
 makeblastdb -in  ${blastdb}.fasta -parse_seqids -out ${blastdb} -dbtype nucl -logfile  ${blastdb}.log
 echo "Done"
 ((n++))
 blastout="Blast/BlastOut/Blast${n}"
done < BioProjList.txt

echo  "End time: "
date +"%d %B %Y %H:%M:%S"


