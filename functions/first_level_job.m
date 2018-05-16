function [matlabbatch] = first_level_job(path_all, file_dir, out_dir)

%-----------------------------------------------------------------------
% Job saved on 09-May-2018 14:06:33 by cfg_util (rev $Rev: 6942 $)
% spm SPM - SPM12 (7219)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {file_dir};
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^rp';
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{2}.spm.stats.fmri_spec.dir = {out_dir};
matlabbatch{2}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{2}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
%%
matlabbatch{2}.spm.stats.fmri_spec.sess.scans = path_all;
%%
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).name = '1-back';
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).onset = [4
                                                         72
                                                         140
                                                         208
                                                         276
                                                         344
                                                         412
                                                         480
                                                         548
                                                         616];
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).duration = 30;
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).orth = 1;
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).name = '2-back';
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).onset = [38
                                                         106
                                                         174
                                                         242
                                                         310
                                                         378
                                                         446
                                                         514
                                                         582
                                                         650];
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).duration = 30;
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).orth = 1;
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(3).name = 'intro';
%%
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(3).onset = [0
                                                         34
                                                         68
                                                         102
                                                         136
                                                         170
                                                         204
                                                         238
                                                         272
                                                         306
                                                         340
                                                         374
                                                         408
                                                         442
                                                         476
                                                         510
                                                         544
                                                         578
                                                         612
                                                         646];
%%
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(3).duration = 4;
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(3).orth = 1;
matlabbatch{2}.spm.stats.fmri_spec.sess.multi = {''};
matlabbatch{2}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
matlabbatch{2}.spm.stats.fmri_spec.sess.multi_reg(1) = cfg_dep('File Selector (Batch Mode): Selected Files (^rp)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{2}.spm.stats.fmri_spec.sess.hpf = 128;
matlabbatch{2}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{2}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{2}.spm.stats.fmri_spec.volt = 1;
matlabbatch{2}.spm.stats.fmri_spec.global = 'None';
matlabbatch{2}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{2}.spm.stats.fmri_spec.mask = {''};
matlabbatch{2}.spm.stats.fmri_spec.cvi = 'AR(1)';
matlabbatch{3}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{3}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{3}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{4}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{4}.spm.stats.con.consess{1}.tcon.name = 'T_1-back-2-back';
matlabbatch{4}.spm.stats.con.consess{1}.tcon.weights = [1 -1 0];
matlabbatch{4}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{4}.spm.stats.con.consess{2}.tcon.name = 'T_2-back-1-back';
matlabbatch{4}.spm.stats.con.consess{2}.tcon.weights = [-1 1 0];
matlabbatch{4}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{4}.spm.stats.con.consess{3}.tcon.name = 'T_effect_of_1-back';
matlabbatch{4}.spm.stats.con.consess{3}.tcon.weights = [1 0 0];
matlabbatch{4}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
matlabbatch{4}.spm.stats.con.consess{4}.tcon.name = 'T_effect_of_2-back';
matlabbatch{4}.spm.stats.con.consess{4}.tcon.weights = [0 1 0];
matlabbatch{4}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
matlabbatch{4}.spm.stats.con.consess{5}.fcon.name = 'F_1-back_vs_2-back';
matlabbatch{4}.spm.stats.con.consess{5}.fcon.weights = [1 0 0
                                                        0 1 0];
matlabbatch{4}.spm.stats.con.consess{5}.fcon.sessrep = 'none';
matlabbatch{4}.spm.stats.con.consess{6}.fcon.name = 'F_effect_of_1-back';
matlabbatch{4}.spm.stats.con.consess{6}.fcon.weights = [1 0 0];
matlabbatch{4}.spm.stats.con.consess{6}.fcon.sessrep = 'none';
matlabbatch{4}.spm.stats.con.consess{7}.fcon.name = 'F_effect_of_2-back';
matlabbatch{4}.spm.stats.con.consess{7}.fcon.weights = [0 1 0];
matlabbatch{4}.spm.stats.con.consess{7}.fcon.sessrep = 'none';
matlabbatch{4}.spm.stats.con.delete = 0;
matlabbatch{5}.spm.stats.results.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{5}.spm.stats.results.conspec(1).titlestr = '';
matlabbatch{5}.spm.stats.results.conspec(1).contrasts = 1;
matlabbatch{5}.spm.stats.results.conspec(1).threshdesc = 'FWE';
matlabbatch{5}.spm.stats.results.conspec(1).thresh = 0.05;
matlabbatch{5}.spm.stats.results.conspec(1).extent = 0;
matlabbatch{5}.spm.stats.results.conspec(1).conjunction = 1;
matlabbatch{5}.spm.stats.results.conspec(1).mask.none = 1;
matlabbatch{5}.spm.stats.results.conspec(2).titlestr = '';
matlabbatch{5}.spm.stats.results.conspec(2).contrasts = 2;
matlabbatch{5}.spm.stats.results.conspec(2).threshdesc = 'FWE';
matlabbatch{5}.spm.stats.results.conspec(2).thresh = 0.05;
matlabbatch{5}.spm.stats.results.conspec(2).extent = 0;
matlabbatch{5}.spm.stats.results.conspec(2).conjunction = 1;
matlabbatch{5}.spm.stats.results.conspec(2).mask.none = 1;
matlabbatch{5}.spm.stats.results.conspec(3).titlestr = '';
matlabbatch{5}.spm.stats.results.conspec(3).contrasts = 3;
matlabbatch{5}.spm.stats.results.conspec(3).threshdesc = 'FWE';
matlabbatch{5}.spm.stats.results.conspec(3).thresh = 0.05;
matlabbatch{5}.spm.stats.results.conspec(3).extent = 0;
matlabbatch{5}.spm.stats.results.conspec(3).conjunction = 1;
matlabbatch{5}.spm.stats.results.conspec(3).mask.none = 1;
matlabbatch{5}.spm.stats.results.conspec(4).titlestr = '';
matlabbatch{5}.spm.stats.results.conspec(4).contrasts = 4;
matlabbatch{5}.spm.stats.results.conspec(4).threshdesc = 'FWE';
matlabbatch{5}.spm.stats.results.conspec(4).thresh = 0.05;
matlabbatch{5}.spm.stats.results.conspec(4).extent = 0;
matlabbatch{5}.spm.stats.results.conspec(4).conjunction = 1;
matlabbatch{5}.spm.stats.results.conspec(4).mask.none = 1;
matlabbatch{5}.spm.stats.results.conspec(5).titlestr = '';
matlabbatch{5}.spm.stats.results.conspec(5).contrasts = 5;
matlabbatch{5}.spm.stats.results.conspec(5).threshdesc = 'FWE';
matlabbatch{5}.spm.stats.results.conspec(5).thresh = 0.05;
matlabbatch{5}.spm.stats.results.conspec(5).extent = 0;
matlabbatch{5}.spm.stats.results.conspec(5).conjunction = 1;
matlabbatch{5}.spm.stats.results.conspec(5).mask.none = 1;
matlabbatch{5}.spm.stats.results.conspec(6).titlestr = '';
matlabbatch{5}.spm.stats.results.conspec(6).contrasts = 6;
matlabbatch{5}.spm.stats.results.conspec(6).threshdesc = 'FWE';
matlabbatch{5}.spm.stats.results.conspec(6).thresh = 0.05;
matlabbatch{5}.spm.stats.results.conspec(6).extent = 0;
matlabbatch{5}.spm.stats.results.conspec(6).conjunction = 1;
matlabbatch{5}.spm.stats.results.conspec(6).mask.none = 1;
matlabbatch{5}.spm.stats.results.conspec(7).titlestr = '';
matlabbatch{5}.spm.stats.results.conspec(7).contrasts = 7;
matlabbatch{5}.spm.stats.results.conspec(7).threshdesc = 'FWE';
matlabbatch{5}.spm.stats.results.conspec(7).thresh = 0.05;
matlabbatch{5}.spm.stats.results.conspec(7).extent = 0;
matlabbatch{5}.spm.stats.results.conspec(7).conjunction = 1;
matlabbatch{5}.spm.stats.results.conspec(7).mask.none = 1;
matlabbatch{5}.spm.stats.results.units = 1;
matlabbatch{5}.spm.stats.results.export{1}.ps = true;
