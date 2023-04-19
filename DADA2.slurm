#!/bin/sh -l

#SBATCH --nodes=1
#SBATCH --tasks-per-node=80
#SBATCH --time=24:00:00
#SBATCH --job-name MetaAnalysis
#SBATCH -A microbiome

###################################################################

echo "start time"
date +"%d %B %Y %H:%M:%S"

cd /scratch/bell/avijiela/Project/Analysis


echo "loading bioinfo"
module load bioinfo


echo "loading Qiime"
module load Qiime/2-2022.8

while IFS=$'\t' read BioProj lib ftrim ftrunc rtrim rtrunc
do 
if [[ "${lib}" == "PE" ]]
then
qiime dada2 denoise-paired --i-demultiplexed-seqs ${BioProj}/${BioProj}_demux.qza --p-trim-left-f ${ftrim} --p-trim-left-r ${rtrim} --p-trunc-len-f ${ftrunc} --p-trunc-len-r ${rtrunc} --o-representative-sequences ${BioProj}/${BioProj}_repseqs.qza --o-table ${BioProj}/${BioProj}_table.qza --o-denoising-stats ${BioProj}/${BioProj}_stats.qza --p-n-threads 80 --verbose
else
qiime dada2 denoise-single --i-demultiplexed-seqs ${BioProj}/${BioProj}_demux.qza --p-trim-left ${ftrim} --p-trunc-len ${ftrunc} --o-representative-sequences ${BioProj}/${BioProj}_repseqs.qza --o-table ${BioProj}/${BioProj}_table.qza --o-denoising-stats ${BioProj}/${BioProj}_stats.qza --p-n-threads 80 --verbose 
fi
qiime metadata tabulate --m-input-file ${BioProj}/${BioProj}_stats.qza --o-visualization ${BioProj}/${BioProj}_stats.qzv
qiime feature-table summarize --i-table ${BioProj}/${BioProj}_table.qza --o-visualization ${BioProj}/${BioProj}_table.qzv --m-sample-metadata-file ../Metadata/${BioProj}.tsv
qiime feature-table tabulate-seqs --i-data ${BioProj}/${BioProj}_repseqs.qza --o-visualization ${BioProj}/${BioProj}_repseqs.qzv
done < DADA2_parameters1.tsv

echo "end time"
date +"%d %B %Y %H:%M:%S"


