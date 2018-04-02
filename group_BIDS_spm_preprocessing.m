% Group SPM preprocessing script for longitudinal data in BIDS
%
% Script prepared for preprocessing of fMRI data obtained for research project: 
% "Temporal dynamics of functional connectivity changes induced by cognitive training", 
% in which participants were fMRI scanned four time during intensive working memory training. 
% 
% Script iterates over all subjects, 4 scanning sessions and selected tasks. 
%
% SPM12 batch functions perform a standard fMRI data preprocessing
% pipeline (slice-timing, head motion correction, coregistration functional data to structural,
% new unified segmentation-normalization, and smoothing (8x8x8). 
%
% Karolina Finc, Centre for Modern Interdisciplinary Technologies, NCU
%
% Last update: 31.03.2018

%% SETUP
clear; clc;

top_dir = '/home/finc/Downloads/LearningBrain/'; % directory with raw subjects' data
out_dir = '/home/finc/Downloads/LearningBrain/derivatives/spm_preprocessing/'; % output directory
cd(top_dir)

all_files = dir(fullfile(top_dir, 'sub*')); % looking for subject's folders
subjects = {all_files.name}; % creating cell array with subjects' IDs    
sessions = {'ses-1' 'ses-2' 'ses-3' 'ses-4'}; % specify names of folders with sessions (when londitudinal data)
func = {'func'}; % specify name of folder with functional data
anat = {'anat'}; % specify name of folder with structural data
tasks = {'rest', 'spatialnback', 'audionback', 'dualnback'};  % specify names of tasks


%% MAIN LOOP
log_file = fopen(fullfile(out_dir, 'preprocessing.log'), 'a'); % creating log file for storing information about missing data

% iterates over subjects
for i = 1: length(subjects)
    
    % iterates over sessions
    for j = 1: length(sessions)

        % --------------------------- CHECKS AND MAKES FOLDERS ---------------------------

        sub_files.raw.sess.anat = create_path(top_dir, subjects{i}, sessions{j}, anat{1});
        sub_files.prep.sess.anat = create_path(out_dir, subjects{i}, sessions{j}, anat{1});

        file.anat =  strcat(subjects{i}, '_', sessions{j}, '_T1w.nii');
        path.anat = fullfile(sub_files.raw.sess.anat, file.anat);

        % checks if there is an anatomical file
        if ~exist(path.anat, 'file')      
           fprintf(log_file, 'No %s data found: %s %s\n', anat{1}, subjects{i}, sessions{j});
        else
            

            % --------------------------- MAKES A COPY OF ANAT FILE ---------------------------

            % creates anat folder for output data
            if ~exist(fullfile(sub_files.prep.sess.anat, file.anat), 'file')
                fprintf('Copying %s data: %s %s \n', anat{1}, subjects{i}, sessions{j});
                fprintf('======================================================================== \n');
                mkdir(create_path(out_dir, subjects{i}, sessions{j}, ''), anat{1}); 
            end
            
            cd(sub_files.prep.sess.anat);
            copyfile(path.anat, sub_files.prep.sess.anat, 'f');
            

            % --------------------------- SEGMENT & NORMALIZE ANAT FILE ---------------------------

            % specifies matlabbatch variable with subject-specific inputs
            matlabbatch = batch_anat_job(sub_files.prep.sess.anat, file.anat);

            % runs matlabbatch job
            fprintf('Segmentation & normalization of %s file: %s %s \n', anat{1}, subjects{i}, sessions{j});
            fprintf('======================================================================== \n');
            spm_jobman('initcfg')
            spm('defaults', 'FMRI');
            spm_jobman('serial', matlabbatch);
            
            % iterates over tasks
            for k = 1: length(tasks)
                
                sub_files.raw.sess.func = create_path(top_dir, subjects{i}, sessions{j}, func{1});
                sub_files.prep.sess.func = create_path(out_dir, subjects{i}, sessions{j}, func{1});
                                
                file.task = strcat(subjects{i}, '_', sessions{j}, '_task-', tasks{k}, '_bold.nii');
                path.func = fullfile(sub_files.raw.sess.func, file.task);
                path.task = fullfile(sub_files.prep.sess.func, tasks{k});

                % checks if there is a functional data
                if ~exist(path.func, 'file')
                    fprintf(log_file, 'No %s %s data found: %s %s\n', tasks{k}, func{1}, subjects{i}, sessions{j});
                else      
                    
                    % --------------------------- MAKES A COPY OF FUNC FILE ---------------------------

                    % creates func folder for output data 
                    if ~exist(fullfile(path.task, file.task), 'file')
                        fprintf('Copying %s %s data: %s %s \n', tasks{k}, func{1}, subjects{i}, sessions{j});
                        fprintf('======================================================================== \n');
                        mkdir(sub_files.prep.sess.func, tasks{k});
                        copyfile(path.func, path.task, 'f');
                    end
                    
                    
                    % --------------------------- PREPROCESS OF FUNC FILE ---------------------------
                    cd(path.task);                    

                    % specifies matlabbatch variable with subject-specific inputs
                    matlabbatch = batch_func_job(path.task, sub_files.prep.sess.anat, file.task, file.anat);

                    %runs matlabbatch job
                    fprintf('Preprocessing of %s task data: %s %s \n', tasks{k},  subjects{i}, sessions{j})
                    fprintf('======================================================================== \n')
                    spm_jobman('initcfg')
                    spm('defaults', 'FMRI');
                    spm_jobman('serial', matlabbatch);
                    
                    % --------------------------- DELETING UNNECESSARY FUNC FILES ---------------------------
                    
                    % just for saving some disk space
                    fprintf('Deleting unnecessary files of %s %s data: %s %s \n', tasks{k}, func{1}, subjects{i}, sessions{j})
                    fprintf('======================================================================== \n')
                    
                    del.files{1} = file.task; % raw functional file
                    del.files{2} = strcat('a_', file.task); % data after slice-timing
                    del.files{3} = strcat('ra_', file.task); % data after realignment
                    
                    cd(path.task);
                    
                    for l = 1: numel(del.files)
                        delete(del.files{l}); 
                    end
                                       
                    fprintf('Done \n');
                    fprintf('======================================================================== \n')


                end
            end
        end
    end
end

fclose(log_file);

 
