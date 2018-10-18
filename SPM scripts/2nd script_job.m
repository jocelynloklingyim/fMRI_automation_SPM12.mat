%-----------------------------------------------------------------------
% Job saved on 22-Jul-2018 16:25:40 by cfg_util (rev $Rev: 6942 $)
% spm SPM - SPM12 (7219)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.stats.factorial_design.dir = {'C:\CBD\MID_MRI\SecondLevel'};
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(1).scans = '<UNDEFINED>';
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(2).scans = '<UNDEFINED>';
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(3).scans = '<UNDEFINED>';
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(4).scans = '<UNDEFINED>';
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(5).scans = '<UNDEFINED>';
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(6).scans = '<UNDEFINED>';
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(7).scans = '<UNDEFINED>';
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(8).scans = '<UNDEFINED>';
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(9).scans = '<UNDEFINED>';
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(10).scans = '<UNDEFINED>';
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(11).scans = '<UNDEFINED>';
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(12).scans = '<UNDEFINED>';
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(13).scans = '<UNDEFINED>';
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(14).scans = '<UNDEFINED>';
matlabbatch{1}.spm.stats.factorial_design.des.pt.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.pt.ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'A>B';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'B>A';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [-1 1];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;
