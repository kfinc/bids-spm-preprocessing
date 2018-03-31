# BIDS_spm_preprocessing

Group SPM preprocessing script for longitudinal data in BIDS (Brain Imaging Data Structure)

Script and functions are prepared for preprocessing of fMRI data obtained for my research project: 
"Temporal dynamics of functional connectivity changes induced by cognitive training", 
in which participants were fMRI scanned four time during intensive working memory training. 

Script iterates over all subjects, 4 scanning sessions and selected tasks. 

SPM12 batch functions perform a standard fMRI data preprocessing
pipeline (slice-timing, head motion correction, coregistration functional data to structural,
new unified segmentation-normalization, and smoothing (8x8x8). 
