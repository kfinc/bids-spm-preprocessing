function [] = batch_spm_preprocessing()

% Function prepared for preprocessing of fMRI data obtained for my research
% project: "Temporal dynamics of functional connectivity changes induced by cognitive training", 
% in which participants were fMRI scanned four time during intensive working memory training. 
% 
% Function iterates SPM12 preprocessing batch over all subjects and 4 scanning sessions. 

% Function with SPM12 batch (see below) performs a standard fMRI data preprocessing
% pipeline (slice-timing, head motion correction, coregistration,
% new unified segmentation-normalization, smoothing (8x8x8). 

clear;clc;

% SETUP

curdir = '/media/finc/Elements/'; % current directory
 
outLabel = 'batch_preprocessing'; % output label

topDir = '/media/finc/Elements/LearningBrain_audio_data/'; % directory with subjects' data
allFiles = dir(topDir);
allDir = allFiles([allFiles(:).isdir]); % lodading all files directories
allDir = allDir(arrayfun(@(x) x.name(1), allDir) ~= '.'); % getting rid of dots

subjects = {allDir.name}; % creating cell array with subjects' IDs    

sessions = {'1' '2' '3' '4'}; % specify names of folders with sessions (when londitudinal data)
fun = {'na'}; % specify name of folder with functional data
t1 = {'t1'}; % specify name of folder with structural data

% specify prefix of raw functional and structural in .nii format
filter = {'^20'};

% Iterating across all subjects and sessions

for i = 36:length(subjects)
    for j = 1: length(sessions)
        
    %Define variables for individual subjects
    Setup.curSubj = subjects{i};
    Setup.curSess = sessions{j};
    Setup.dataDir = strcat(topDir, Setup.curSubj, '/', Setup.curSess, '/');
    Setup.runs = fun;
    Setup.anatDir = t1;
    Setup.filter = filter;
    
    % when there is missing data for current subject, move to next
    % directory
    
    if exist([Setup.dataDir Setup.runs{1}]) == 0
        sprintf('No data found for subject %d\n session %d\n', i, j)
    else
    
    %specify matlabbatch variable with subject-specific inputs
    matlabbatch = batch_job(Setup);
 
    %save matlabbatch variable 
    outName = strcat(Setup.dataDir,outLabel,'_',date);
    save(outName, 'matlabbatch');
        
    %run matlabbatch job
    cd(Setup.dataDir);
    try
        sprintf('preprocessing of subject %d\n session %d\n', i, j)
        spm_jobman('initcfg')
        spm('defaults', 'FMRI');
        spm_jobman('serial', matlabbatch);
    catch
        cd(curdir);
        continue;
    end
    cd(curdir);
    end
 
    end
end 
end


%-----------------------------------------------------------------------
% Job saved on 29-Dec-2017 16:17:08 by cfg_util (rev $Rev: 6460 $)
% spm SPM - SPM12 (6470)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------


function [matlabbatch]=batch_job(Setup)

Setup.selector = strcat({'File Selector (Batch Mode): Selected Files'}, {' '}, {'('}, Setup.filter{1}, {')'});

matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {[Setup.dataDir Setup.runs{1} '/']};
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.filter = Setup.filter{1};
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {[Setup.dataDir Setup.anatDir{1} '/']};
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.filter = Setup.filter{1};
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{3}.spm.temporal.st.scans{1}(1) = cfg_dep(Setup.selector, substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{3}.spm.temporal.st.nslices = 42;
matlabbatch{3}.spm.temporal.st.tr = 2;
matlabbatch{3}.spm.temporal.st.ta = 1.95238095238095;
matlabbatch{3}.spm.temporal.st.so = [1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35 37 39 41 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42];
matlabbatch{3}.spm.temporal.st.refslice = 1;
matlabbatch{3}.spm.temporal.st.prefix = 'a';
matlabbatch{4}.spm.spatial.realign.estwrite.data{1}(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 1)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
matlabbatch{4}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
matlabbatch{4}.spm.spatial.realign.estwrite.eoptions.sep = 4;
matlabbatch{4}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
matlabbatch{4}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
matlabbatch{4}.spm.spatial.realign.estwrite.eoptions.interp = 2;
matlabbatch{4}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
matlabbatch{4}.spm.spatial.realign.estwrite.eoptions.weight = '';
matlabbatch{4}.spm.spatial.realign.estwrite.roptions.which = [2 1];
matlabbatch{4}.spm.spatial.realign.estwrite.roptions.interp = 4;
matlabbatch{4}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
matlabbatch{4}.spm.spatial.realign.estwrite.roptions.mask = 1;
matlabbatch{4}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
matlabbatch{5}.spm.spatial.coreg.estimate.ref(1) = cfg_dep('Realign: Estimate & Reslice: Mean Image', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rmean'));
matlabbatch{5}.spm.spatial.coreg.estimate.source(1) = cfg_dep(Setup.selector, substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{5}.spm.spatial.coreg.estimate.other = {''};
matlabbatch{5}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{5}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{5}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{5}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
matlabbatch{6}.spm.spatial.preproc.channel.vols(1) = cfg_dep('Coregister: Estimate: Coregistered Images', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','cfiles'));
matlabbatch{6}.spm.spatial.preproc.channel.biasreg = 0.001;
matlabbatch{6}.spm.spatial.preproc.channel.biasfwhm = 60;
matlabbatch{6}.spm.spatial.preproc.channel.write = [0 0];
matlabbatch{6}.spm.spatial.preproc.tissue(1).tpm = {'/home/finc/Dropbox/010_MATLAB/spm12/tpm/TPM.nii,1'};
matlabbatch{6}.spm.spatial.preproc.tissue(1).ngaus = 1;
matlabbatch{6}.spm.spatial.preproc.tissue(1).native = [1 0];
matlabbatch{6}.spm.spatial.preproc.tissue(1).warped = [0 0];
matlabbatch{6}.spm.spatial.preproc.tissue(2).tpm = {'/home/finc/Dropbox/010_MATLAB/spm12/tpm/TPM.nii,2'};
matlabbatch{6}.spm.spatial.preproc.tissue(2).ngaus = 1;
matlabbatch{6}.spm.spatial.preproc.tissue(2).native = [1 0];
matlabbatch{6}.spm.spatial.preproc.tissue(2).warped = [0 0];
matlabbatch{6}.spm.spatial.preproc.tissue(3).tpm = {'/home/finc/Dropbox/010_MATLAB/spm12/tpm/TPM.nii,3'};
matlabbatch{6}.spm.spatial.preproc.tissue(3).ngaus = 2;
matlabbatch{6}.spm.spatial.preproc.tissue(3).native = [1 0];
matlabbatch{6}.spm.spatial.preproc.tissue(3).warped = [0 0];
matlabbatch{6}.spm.spatial.preproc.tissue(4).tpm = {'/home/finc/Dropbox/010_MATLAB/spm12/tpm/TPM.nii,4'};
matlabbatch{6}.spm.spatial.preproc.tissue(4).ngaus = 3;
matlabbatch{6}.spm.spatial.preproc.tissue(4).native = [1 0];
matlabbatch{6}.spm.spatial.preproc.tissue(4).warped = [0 0];
matlabbatch{6}.spm.spatial.preproc.tissue(5).tpm = {'/home/finc/Dropbox/010_MATLAB/spm12/tpm/TPM.nii,5'};
matlabbatch{6}.spm.spatial.preproc.tissue(5).ngaus = 4;
matlabbatch{6}.spm.spatial.preproc.tissue(5).native = [1 0];
matlabbatch{6}.spm.spatial.preproc.tissue(5).warped = [0 0];
matlabbatch{6}.spm.spatial.preproc.tissue(6).tpm = {'/home/finc/Dropbox/010_MATLAB/spm12/tpm/TPM.nii,6'};
matlabbatch{6}.spm.spatial.preproc.tissue(6).ngaus = 2;
matlabbatch{6}.spm.spatial.preproc.tissue(6).native = [0 0];
matlabbatch{6}.spm.spatial.preproc.tissue(6).warped = [0 0];
matlabbatch{6}.spm.spatial.preproc.warp.mrf = 1;
matlabbatch{6}.spm.spatial.preproc.warp.cleanup = 1;
matlabbatch{6}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{6}.spm.spatial.preproc.warp.affreg = 'mni';
matlabbatch{6}.spm.spatial.preproc.warp.fwhm = 0;
matlabbatch{6}.spm.spatial.preproc.warp.samp = 3;
matlabbatch{6}.spm.spatial.preproc.warp.write = [0 1];
matlabbatch{7}.spm.spatial.normalise.write.subj.def(1) = cfg_dep('Segment: Forward Deformations', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','fordef', '()',{':'}));
matlabbatch{7}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep('Realign: Estimate & Reslice: Resliced Images (Sess 1)', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{1}, '.','rfiles'));
matlabbatch{7}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                          78 76 85];
matlabbatch{7}.spm.spatial.normalise.write.woptions.vox = [2 2 2];
matlabbatch{7}.spm.spatial.normalise.write.woptions.interp = 4;
matlabbatch{8}.spm.spatial.normalise.write.subj.def(1) = cfg_dep('Segment: Forward Deformations', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','fordef', '()',{':'}));
matlabbatch{8}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep('Coregister: Estimate: Coregistered Images', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','cfiles'));
matlabbatch{8}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                          78 76 85];
matlabbatch{8}.spm.spatial.normalise.write.woptions.vox = [2 2 2];
matlabbatch{8}.spm.spatial.normalise.write.woptions.interp = 4;
matlabbatch{9}.spm.spatial.normalise.write.subj.def(1) = cfg_dep('Segment: Forward Deformations', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','fordef', '()',{':'}));
matlabbatch{9}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep('Segment: c1 Images', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{1}, '.','c', '()',{':'}));
matlabbatch{9}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                          78 76 85];
matlabbatch{9}.spm.spatial.normalise.write.woptions.vox = [2 2 2];
matlabbatch{9}.spm.spatial.normalise.write.woptions.interp = 4;
matlabbatch{10}.spm.spatial.normalise.write.subj.def(1) = cfg_dep('Segment: Forward Deformations', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','fordef', '()',{':'}));
matlabbatch{10}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep('Segment: c2 Images', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{2}, '.','c', '()',{':'}));
matlabbatch{10}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                           78 76 85];
matlabbatch{10}.spm.spatial.normalise.write.woptions.vox = [2 2 2];
matlabbatch{10}.spm.spatial.normalise.write.woptions.interp = 4;
matlabbatch{11}.spm.spatial.normalise.write.subj.def(1) = cfg_dep('Segment: Forward Deformations', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','fordef', '()',{':'}));
matlabbatch{11}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep('Segment: c3 Images', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{3}, '.','c', '()',{':'}));
matlabbatch{11}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                           78 76 85];
matlabbatch{11}.spm.spatial.normalise.write.woptions.vox = [2 2 2];
matlabbatch{11}.spm.spatial.normalise.write.woptions.interp = 4;
matlabbatch{12}.spm.spatial.smooth.data(1) = cfg_dep('Normalise: Write: Normalised Images (Subj 1)', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
matlabbatch{12}.spm.spatial.smooth.fwhm = [8 8 8];
matlabbatch{12}.spm.spatial.smooth.dtype = 0;
matlabbatch{12}.spm.spatial.smooth.im = 0;
matlabbatch{12}.spm.spatial.smooth.prefix = 's8';

end