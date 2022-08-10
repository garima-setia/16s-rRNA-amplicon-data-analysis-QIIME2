#!/bin/bash
###16S rRNA gene amplicon sequencing data analysis using QIIME2###

source activate qiime2-2022.2

#Demultiplex (Sort individuals into samples)
#For PairedEnd sequences
qiime tools import 
  --type ‘SampleData[PairedEndSequencesWithQuality]' 
  --input-path rawreads/ 
  --input-format CasavaOneEightSingleLanePerSampleDirFmt 
  --output-path demux-paired.qza
  
#For SingleEnd sequences
qiime tools import 
  --type 'SampleData[SequencesWithQuality]' 
  --input-path rawreads/ 
  --input-format CasavaOneEightSingleLanePerSampleDirFmt 
  --output-path demux-single.qza

#Visualization:
qiime demux summarize 
  -–i-data demux-paired.qza 
  -–o-visualization demux-paired.qzv
