#!/bin/bash
#Rarefaction:
  nohup qiime diversity alpha-rarefaction 
    --i-table table.qza 
    --i-phylogeny rooted-tree.qza 
    --p-min-depth 1 
    --p-max-depth 7411  
    --p-steps 1000 
    --m-metadata-file metadata.txt 
    --o-visualization alpha-rarefaction

#Diversity:
qiime metadata tabulate 
  --m-input-file taxonomy_16s_99.qza 
  --o-visualization taxonomy_16s_99.qzv

qiime diversity core-metrics-phylogenetic 
    --i-phylogeny rooted-tree.qza 
    --i-table table-filteredgrouped.qza 
    --p-sampling-depth 7411  
    --m-metadata-file metadata.txt 
    --output-dir core-metrics-results-grouped

qiime feature-table summarize 
    --i-table core-metrics-results-grouped/rarefied_table.qza 
    --o-visualization rarefied_table.qzv 
    --m-sample-metadata-file metadata.txt

#Alpha-Diversity
qiime diversity alpha-group-significance 
    --i-alpha-diversity core-metrics-results-grouped/faith_pd_vector.qza 
    --m-metadata-file metadata.txt 
    --o-visualization core-metrics-results-grouped/faith-pd-group-significance.qzv

qiime diversity alpha-group-significance 
    --i-alpha-diversity core-metrics-results-grouped/observed_features_vector.qza 
    --m-metadata-file metadata.txt
    --o-visualization core-metrics-results-grouped/observed-features-significance.qzv

qiime diversity alpha-group-significance 
    --i-alpha-diversity core-metrics-results-grouped/evenness_vector.qza 
    --m-metadata-file metadata.txt
    --o-visualization core-metrics-results-grouped/evenness-group-significance.qzv

qiime diversity alpha-group-significance 
    --i-alpha-diversity core-metrics-results-grouped/shannon_vector.qza 
    --m-metadata-file metadata.txt
    --o-visualization core-metrics-results-grouped/shannon-group-significance.qzv

qiime diversity alpha-correlation 
    --i-alpha-diversity core-metrics-results-grouped/faith_pd_vector.qza 
    --m-metadata-file metadata.txt
    --o-visualization core-metrics-results-grouped/faith-pd-correlation.qzv

qiime diversity alpha-correlation 
    --i-alpha-diversity core-metrics-results-grouped/evenness_vector.qza 
    --m-metadata-file metadata.txt
    --o-visualization core-metrics-results-grouped/evenness-correlation.qzv

qiime diversity alpha-correlation 
    --i-alpha-diversity core-metrics-results-grouped/shannon_vector.qza 
    --m-metadata-file metadata.txt 
    --o-visualization core-metrics-results-grouped/shannon-correlation.qzv

qiime diversity alpha-correlation 
    --i-alpha-diversity core-metrics-results-grouped/observed_features_vector.qza 
    --m-metadata-file metadata.txt
    --o-visualization core-metrics-results-grouped/observed_features-correlation.qzv

#Beta-Diversity
qiime diversity beta-group-significance 
    --i-distance-matrix core-metrics-results-grouped/weighted_unifrac_distance_matrix.qza 
    --m-metadata-file metadata.txt
    --m-metadata-column factor 
    --o-visualization core-metrics-results-grouped/weighted-unifrac-factor-group-significance.qzv 
    --p-pairwise

#Visualization 
qiime emperor plot 
    --i-pcoa core-metrics-results/unweighted_unifrac_pcoa_results.qza --m-metadata-file metadata.txt
    --o-visualization core-metrics-results/unweighted-unifrac-emperor-factor.qzv

qiime emperor plot 
    --i-pcoa core-metrics-results/weighted_unifrac_pcoa_results.qza 
    --m-metadata-file metadata.txt
    --o-visualization core-metrics-results/weighted-unifrac-emperor-factor.qzv

qiime emperor plot 
    --i-pcoa core-metrics-results/bray_curtis_pcoa_results.qza 
    --m-metadata-file metadata.txt 
    --o-visualization core-metrics-results/bray-curtis-emperor-factor.qzv


#ADONIS
 
qiime diversity adonis 
    --i-distance-matrix core-metrics-results-grouped/unweighted_unifrac_distance_matrix.qza 
    --p-formula "Rs*AltitudeClassification*ParentMaterialClassification”
    --m-metadata-file metadata.txt
    --o-visualization weighted_unifrac_adonis_Rs*Altitude Classification*Parent Material Classification

#PERMANOVA

qiime diversity beta-group-significance 
    --i-distance-matrix core-metrics-results-grouped/weighted_unifrac_distance_matrix.qza 
    --m-metadata-file metadata.txt
    --m-metadata-column Rs 
    --p-method permanova 
    --p-pairwise --p-permutations 1000 
    --o-visualization Rs_permanova_weighted_unifrac

qiime diversity beta-group-significance 
    --i-distance-matrix core-metrics-results-grouped/weighted_unifrac_distance_matrix.qza 
    --m-metadata-file metadata.txt
    --m-metadata-column Altitude Classification 
    --p-method permanova 
    --p-pairwise 
    --p-permutations 1000 
    --o-visualization Altitude_Classification_permanova_weighted_unifrac

qiime diversity beta-group-significance 
    --i-distance-matrix core-metrics-results-grouped/weighted_unifrac_distance_matrix.qza 
    --m-metadata-file metadata.txt
    --m-metadata-column Parent Material Classification 
    --p-method permanova 
    --p-pairwise 
    --p-permutations 1000 
    --o-visualization Parent Material Classification_permanova_weighted_unifrac

#PERMDISP

qiime diversity beta-group-significance 
    --i-distance-matrix core-metrics-results-grouped/weighted_unifrac_distance_matrix.qza 
    --m-metadata-file metadata.txt
    --m-metadata-column Rs 
    --p-method permdisp 
    --p-pairwise 
    --p-permutations 1000 
    --o-visualization Rs_permdisp_weighted_unifrac

qiime diversity beta-group-significance 
    --i-distance-matrix core-metrics-results-grouped/weighted_unifrac_distance_matrix.qza 
    --m-metadata-file metadata.txt
    --m-metadata-column Altitude Classification 
    --p-method permdisp 
    --p-pairwise 
    --p-permutations 1000 
    --o-visualization AltitudeClassification_permdisp_weighted_unifrac

qiime diversity beta-group-significance 
    --i-distance-matrix core-metrics-results-grouped/weighted_unifrac_distance_matrix.qza 
    --m-metadata-file metadata.txt
    --m-metadata-column ParentMaterialClassification --p-method permdisp 
    --p-pairwise 
    --p-permutations 1000 
    --o-visualization Parent MaterialClassification_permdisp_weighted_unifrac

#ANCOM-BC

qiime ancombc ancombc 
    --i-table table-filteredgrouped.qza 
    --m-metadata-file metadata.txt 
    --p-formula "Rs" 
    --o-differentials ancombc_filtered_Rs_differentials.qza

qiime metadata tabulate 
    --m-input-file ancombc_filtered_Rs_differentials.qza 
    --m-input-file taxonomy_16s_99.qza 
    --o-visualization ancombc_filtered_Rs_differentials.qzv

qiime ancombc ancombc 
    --i-table table-filteredgrouped.qza 
    --m-metadata-file metadata.txt 
    --p-formula "altitudeclassification" 
    --o-differentials ancombc_filtered_altitudeclassification_differentials.qza

qiime metadata tabulate 
    --m-input-file ancombc_filtered_altitudeclassification_differentials.qza 
    --m-input-file taxonomy_16s_99.qza 
    --o-visualization ancombc_filtered_altitudeclassification_differentials.qzv