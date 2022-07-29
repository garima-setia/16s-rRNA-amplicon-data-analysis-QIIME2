#!/bin/bash

#DADA2:
#For paired samples
qiime dada2 denoise-paired
  --i-demultiplexed-seqs demux-paired.qza 
  --p-trim-left-f 20 
  --p-trim-left-r 18 
  --p-trunc-len-f 251 
  --p-trunc-len-r 251 
  --p-n-threads 48 
  --output-dir dada2_output 
  --verbose
	
#For single samples
qiime dada2 denoise-single 
  --i-demultiplexed-seqs demux-single-end.qza 
  --p-trim-left 20 
  --p-trunc-len 251 
  --p-n-threads 48 
  --output-dir dada2_output_forward 
  –-verbose

#Visualization:
qiime feature-table summarize 
  --i-table table.qza 
  --o-visualization table.qzv 
  --m-sample-metadata-file metadata.txt

qiime feature-table tabulate-seqs 
  --i-data representative_sequences.qza 
  --o-visualization representative_sequences.qzv

#Subsample merging (grouped)

qiime feature-table group 
  --i-table table.qza 
  --p-axis sample 
  --m-metadata-file metadata.txt 
  --m-metadata-column sample 
  --p-mode mean-ceiling 
  --o-grouped-table tablegrouped.qza

qiime feature-table summarize 
  --i-table tablegrouped.qza 
  --o-visualization tablegrouped.qzv 
  --m-sample-metadata-file metadatagrouped.txt

#Or 

qiime feature-table merge 
  --i-tables table-1.qza table-2.qza 
  --p-overlap-method sum  
	--o-merged-table merged-table.qza
		
qiime feature-table summarize 
  --i-table merged-table.qza
  --o-visualization merged-table.qzv
  --m-sample-metadata-file metadata.txt
	
qiime feature-table merge-seqs 
	--i-data representative_sequeneces1.qza
	--i-data representative_sequeneces2.qza
	--o-merged-data merged-rep-seqs.qza