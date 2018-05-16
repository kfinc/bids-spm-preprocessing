% FIRST LEVEL ANALYSIS
%
% Karolina Finc, Centre for Modern Interdisciplinary Technologies, NCU
%
% Last update: 08.05.2018

%% SETUP
clear; clc;

top_dir = '/media/finc/Elements/LearningBrain_training_prep/'; % directory with raw subjects' data
out_dir = '/media/finc/Elements/LearningBrain_analysis/first_level_dual/' ; % output directory

all_files = dir(fullfile(top_dir, 'sub*')); % looking for subject's folders
subjects = {all_files.name}; % creating cell array with subjects' IDs    
sessions = {'ses-1' 'ses-2' 'ses-3' 'ses-4'}; % specify names of folders with sessions (when londitudinal data)
func = {'func'}; % specify name of folder with functional data
tasks = {'dualnback'};  % specify names of tasks


%% MAIN LOOP
log_file = fopen(fullfile(out_dir, 'preprocessing.log'), 'a'); % creating log file for storing information about missing data

% iterates over subjects
for i = 16: length(subjects)
    
    % iterates over sessions
    for j = 1: length(sessions)
          
        % iterates over tasks
        for k = 1: length(tasks)

            sub_files.prep.sess.func = strcat(top_dir, subjects{i}, '/', sessions{j}, '/', func{1}, '/', tasks{k});
            sub_files.analysis.sess.func = strcat(out_dir, subjects{i}, '/', sessions{j}, '/', func{1},'/');
            mkdir(sub_files.analysis.sess.func)
            
            file.task = strcat('s8wra_', subjects{i}, '_', sessions{j}, '_task-', tasks{k}, '_bold.nii');
            path.func = fullfile(sub_files.prep.sess.func, file.task);
            
            path_all = {1:340};

            for n = 1: 340
                path_all{n,1} = strcat(path.func, ',', num2str(n)); 
            end

            % checks if there is a functional data
            if ~ exist(sub_files.prep.sess.func, 'dir') 
                fprintf(log_file,'No %s %s data found: %s %s\n', tasks{k}, func{1}, subjects{i}, sessions{j});
            else      

                  % --------------------------- PREPROCESS OF FUNC FILE ---------------------------
                    cd(sub_files.analysis.sess.func);                    

                    % specifies matlabbatch variable with subject-specific inputs
                    matlabbatch = first_level_job(path_all, sub_files.prep.sess.func,sub_files.analysis.sess.func);

                    %runs matlabbatch job
                    fprintf('First level analysis of %s task data: %s %s \n', tasks{k},  subjects{i}, sessions{j})
                    fprintf('======================================================================== \n')
                    spm_jobman('initcfg')
                    spm('defaults', 'FMRI');
                    spm_jobman('serial', matlabbatch);

            end       
        end
    end
end


