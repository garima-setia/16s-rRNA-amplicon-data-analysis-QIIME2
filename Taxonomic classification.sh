#!/bin/bash

#Taxonomy Classification
qiime feature-classifier classify-consensus-blast 
  --i-query representative_sequences.qza  
  --i-reference-taxonomy majority_taxonomy_7_levels.qza 
  --i-reference-reads 99_otus_16s.qza 
  --o-classification taxonomy_16s_99 
  --p-perc-identity 0.97  
  --p-maxaccepts 1 

qiime metadata tabulate 
--m-input-file taxonomy_16s_99.qza 
--m-input-file representative_sequences.qza 
--o-visualization repseqtaxonomytable.qzv

qiime alignment mafft 
   --i-sequences representative_sequences.qza 
   --o-alignment aligned-representative_sequences

qiime phylogeny fasttree 
	--i-alignment masked-representative_sequences.qza 
	--o-tree unrooted-tree

qiime phylogeny midpoint-root 
	--i-tree unrooted-tree.qza 
	--o-rooted-tree rooted-tree

#Visualization:
	qiime taxa barplot 
		--i-table table.qza 
		--i-taxonomy taxonomy_16s_99.qza 
		--m-metadata-file metadata.txt 
		--o-visualization taxa-bar-plots

	qiime taxa filter-table 
		--i-table table.qza 
		--i-taxonomy taxonomy_16s_99.qza 
		--p-exclude Unassigned  
		--o-filtered-table table-filtered

  qiime feature-table summarize 
    --i-table table-filtered.qza 
    --o-visualization tablefiltered.qzv 
    --m-sample-metadata-file metadata.txt

  qiime taxa barplot 
		--i-table table-filtered.qza 
		--i-taxonomy taxonomy_16s_99.qza 
		--m-metadata-file metadata.txt 
		--o-visualization taxa-bar-plot-filtered 