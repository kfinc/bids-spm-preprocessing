# batch_spm_preprocessing

Function prepared for preprocessing of fMRI data obtained for my research
project: "Temporal dynamics of functional connectivity changes induced by cognitive training", 
in which participants were fMRI scanned four times during intensive working memory training. 
Function iterates SPM12 preprocessing batch over all subjects and 4 scanning sessions. 

Function with SPM12 batch performs a standard fMRI data preprocessing
pipeline (slice-timing, head motion correction, coregistration,
new unified segmentation-normalization and smoothing (8x8x8)). 
