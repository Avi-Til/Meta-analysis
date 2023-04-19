#!/bin/sh -l

#SBATCH --nodes=1
#SBATCH --tasks-per-node=128
#SBATCH --time=24:00:00
#SBATCH --job-name MetaAnalysis
#SBATCH -A microbiome

###################################################################

echo "Start time:"
date +"%d %B %Y %H:%M:%S"

cd /scratch/bell/avijiela/Project/Analysis

echo "Loading bioinfo..."
module load bioinfo
echo "Done"

echo "Loading Qiime..."
module load Qiime/2-2022.8
echo "Done"

echo "Generating tree for individual studies..."
while read accID
do
echo "Study ID: ${accID}"
qiime phylogeny align-to-tree-mafft-fasttree --i-sequences ${accID}/${accID}_repseqs.qza --o-alignment ${accID}/${accID}_aligned-repseqs.qza --o-masked-alignment ${accID}/${accID}_masked-aligned-repseqs.qza --o-tree ${accID}/${accID}_unrootedtree.qza --o-rooted-tree ${accID}/${accID}_rootedtree.qza --p-n-threads 128
done < BioProjList.txt
echo "Done"

echo "Generating tree for combined data..."
qiime phylogeny align-to-tree-mafft-fasttree --i-sequences Combined/combined_repseqs.qza --o-alignment Combined/combined_aligned-repseqs.qza --o-masked-alignment Combined/combined_masked-aligned-repseqs.qza --o-tree Combined/combined_unrootedtree.qza --o-rooted-tree Combined/combined_rootedtree.qza --p-n-threads 128


echo "end time"
date +"%d %B %Y %H:%M:%S"


