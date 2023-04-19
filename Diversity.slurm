#!/bin/sh -l

#SBATCH --nodes=1
#SBATCH --tasks-per-node=8
#SBATCH --time=24:00:00
#SBATCH --job-name MetaAnalysis
#SBATCH -A microbiome

###################################################################

echo "Start time:"
date +"%d %B %Y %H:%M:%S"

cd /scratch/bell/avijiela/Project/Analysis/Combined

echo "loading bioinfo"
module load bioinfo
echo "Done"

echo "loading Qiime"
module load Qiime/2-2022.8
echo "Done"

#qiime diversity core-metrics-phylogenetic --i-phylogeny Combined_rootedtree.qza --i-table Combined_table.qza --p-sampling-depth 1000 --m-metadata-file ../../Metadata/Combined.tsv --output-dir DiversityResults1000 --p-n-jobs-or-threads 128

#qiime diversity alpha-rarefaction --i-table Combined_table.qza --i-phylogeny Combined_rootedtree.qza --p-max-depth 1000 --m-metadata-file ../../Metadata/Combined.tsv --o-visualization Combined_1000rarefaction.qzv

#qiime diversity alpha-rarefaction --i-table Combined_table.qza --i-phylogeny Combined_rootedtree.qza --p-max-depth 10000 --m-metadata-file ../../Metadata/Combined.tsv --o-visualization Combined_10000rarefaction.qzv

#qiime diversity alpha-rarefaction --i-table Combined_table.qza --i-phylogeny Combined_rootedtree.qza --p-max-depth 100000 --m-metadata-file ../../Metadata/Combined.tsv --o-visualization Combined_100000rarefaction.qzv

qiime diversity alpha-group-significance --i-alpha-diversity DiversityResults1000/shannon_vector.qza --m-metadata-file ../../Metadata/Combined.tsv --o-visualization DiversityResults1000/shannon_results.qzv

qiime diversity alpha-group-significance --i-alpha-diversity DiversityResults1000/evenness_vector.qza --m-metadata-file ../../Metadata/Combined.tsv --o-visualization DiversityResults1000/eveness_results.qzv

qiime diversity beta-group-significance --i-distance-matrix DiversityResults1000/unweighted_unifrac_distance_matrix.qza  --m-metadata-file ../../Metadata/Combined.tsv --m-metadata-column System --o-visualization DiversityResults1000/UnW-UF-System.qzv --p-pairwise

qiime diversity beta-group-significance --i-distance-matrix DiversityResults1000/unweighted_unifrac_distance_matrix.qza  --m-metadata-file ../../Metadata/Combined.tsv --m-metadata-column BioProject --o-visualization DiversityResults1000/UnW-UF-BioProject.qzv --p-pairwise

qiime diversity beta-group-significance --i-distance-matrix DiversityResults1000/unweighted_unifrac_distance_matrix.qza  --m-metadata-file ../../Metadata/Combined.tsv --m-metadata-column ExperimentalCondition --o-visualization DiversityResults1000/UnW-UF-ExperimentalCondition.qzv --p-pairwise

qiime diversity beta-group-significance --i-distance-matrix DiversityResults1000/weighted_unifrac_distance_matrix.qza  --m-metadata-file ../../Metadata/Combined.tsv --m-metadata-column System --o-visualization DiversityResults1000/W-UF-System.qzv --p-pairwise

qiime diversity beta-group-significance --i-distance-matrix DiversityResults1000/weighted_unifrac_distance_matrix.qza  --m-metadata-file ../../Metadata/Combined.tsv --m-metadata-column BioProject --o-visualization DiversityResults1000/W-UF-BioProject.qzv --p-pairwise

qiime diversity beta-group-significance --i-distance-matrix DiversityResults1000/weighted_unifrac_distance_matrix.qza  --m-metadata-file ../../Metadata/Combined.tsv --m-metadata-column ExperimentalCondition --o-visualization DiversityResults1000/W-UF-ExperimentalCondition.qzv --p-pairwise

qiime diversity beta-group-significance --i-distance-matrix DiversityResults1000/bray_curtis_distance_matrix.qza  --m-metadata-file ../../Metadata/Combined.tsv --m-metadata-column System --o-visualization DiversityResults1000/BC-System.qzv --p-pairwise

qiime diversity beta-group-significance --i-distance-matrix DiversityResults1000/bray_curtis_distance_matrix.qza  --m-metadata-file ../../Metadata/Combined.tsv --m-metadata-column BioProject --o-visualization DiversityResults1000/BC-BioProject.qzv --p-pairwise

qiime diversity beta-group-significance --i-distance-matrix DiversityResults1000/bray_curtis_distance_matrix.qza  --m-metadata-file ../../Metadata/Combined.tsv --m-metadata-column ExperimentalCondition --o-visualization DiversityResults1000/BC-ExperimentalCondition.qzv --p-pairwise

echo "end time"
date +"%d %B %Y %H:%M:%S"


