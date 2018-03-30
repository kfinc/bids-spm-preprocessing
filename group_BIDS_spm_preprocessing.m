% Group SPM preprocessing script for longitudinal data in BIDS
%
% Script prepared for preprocessing of fMRI data obtained for research project: 
% "Temporal dynamics of functional connectivity changes induced by cognitive training", 
% in which participants were fMRI scanned four time during intensive working memory training. 
% 
% Script iterates over all subjects, 4 scanning sessions and four tasks. 

% SPM12 batch functions perform a standard fMRI data preprocessing
% pipeline (slice-timing, head motion correction, coregistration,
% new unified segmentation-normalization, and smoothing (8x8x8). 
%
% Karolina Finc, Centre for Modern Interdisciplinary Technologies, NCU
%
% Last update: 30.03.2018

%% SETUP
clear;clc;

top_dir = '/home/finc/Downloads/LearningBrain/'; % directory with raw subjects' data
out_dir = '/home/finc/Downloads/LearningBrain/derivatives/spm_preprocessing/'; % output directory
cd(top_dir)

all_files = dir(fullfile(top_dir, 'sub*')); % looking for subject's folders
subjects = {all_files.name}; % creating cell array with subjects' IDs    
sessions = {'ses-1' 'ses-2' 'ses-3' 'ses-4'}; % specify names of folders with sessions (when londitudinal data)
func = {'func'}; % specify name of folder with functional data
anat = {'anat'}; % specify name of folder with structural data
tasks = {'rest', 'spatialnback', 'audionback', 'dualnback'};


%% MAIN LOOP

% Iterates over all subjects
for i = 4: length(subjects)
    
    % Iterates across all sessions
    for j = 1: length(sessions)

    % -------------- CHECKS AND MAKES FOLDERS --------------  

    sub_files.raw.sess.anat = create_path(top_dir, subjects{i}, sessions{j}, anat{1});
    sub_files.raw.sess.func = create_path(top_dir, subjects{i}, sessions{j}, func{1});
    
    sub_files.prep.sess.anat = create_path(out_dir, subjects{i}, sessions{j}, anat{1});
    sub_files.prep.sess.func = create_path(out_dir, subjects{i}, sessions{j}, func{1});

        % checks if there is an anatomical file
        if not(exist(sub_files.raw.sess.anat, 'dir'))
            warning('No data %s data found for subject %s session %s\n', anat{1}, subjects{i}, sessions{j})
        else
            
            % -------------- MAKES A COPY OF ANAT FILE --------------  
            
            % creates anat folder for output data
            if not(exist(sub_files.prep.sess.anat,'dir'))
                mkdir(create_path(out_dir, subjects{i}, sessions{j}, ''), anat{1})
            end

            files.anat = fullfile(sub_files.raw.sess.anat, 'sub*.nii');
            copyfile(files.anat, sub_files.prep.sess.anat);

            % -------------- SEGMENT & NORMALIZE ANAT FILE --------------  

            %specify matlabbatch variable with subject-specific inputs
            matlabbatch = batch_anat_job(sub_files.prep.sess.anat);
            cd(sub_files.prep.sess.anat);

            %run matlabbatch job
            fprintf('Segmentation of structural file (subject %d session %d) \n', i, j)
            fprintf('======================================================================== \n')
            spm_jobman('initcfg')
            spm('defaults', 'FMRI');
            spm_jobman('serial', matlabbatch);
            
            
            for k = 1: length(tasks)
                
                % checks if there is functional folder
                if not(exist(sub_files.prep.sess.func, 'dir'))
                    warning('No data %s data found for subject %s session %s\n', func{1}, subjects{i}, sessions{j})
                end

                % creates func folder for output data 
                if not(exist(sub_files.prep.sess.func,'dir'))
                    mkdir(create_path(out_dir, subjects{i}, sessions{j}, ''), func{1})
                end

                % -------------- MAKES COPY OF FUNC FILE --------------  

                files.func = fullfile(sub_files.raw.sess.func, 'sub*.nii');
                copyfile(files.func, sub_files.prep.sess.func);
               

                % -------------- PREPROCESS FUNC FILE --------------  

                %specify matlabbatch variable with subject-specific inputs
                matlabbatch = batch_func_job(sub_files.prep.sess.func, sub_files.prep.sess.anat, tasks{k});
                cd(sub_files.prep.sess.func);

                %run matlabbatch job
                fprintf('Functional data preprocessing of %s (subject ds, session %d) \n', k, i, j)
                fprintf('======================================================================== \n')

                spm_jobman('initcfg')
                spm('defaults', 'FMRI');
                spm_jobman('serial', matlabbatch);
            end
        end
    end
end



