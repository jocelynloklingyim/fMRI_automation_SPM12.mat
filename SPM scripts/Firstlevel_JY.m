
%% experiment specific information

subs = [8]; %write in the subs you want to use!
directories.rdir = 'C:\CBD\MID_MRI\MRI- backup\MRI B\subs';     % root directory
directories.wdir = 'FirstLevel';               % directory where subject data kept
%directories.adir = 'C:\CBD\MID_MRI\SecondLevel\subs\P02';                  % directory where analysis to be saved - I think this needs to be improved
sesnum = 1;                                                                 % number of EPI sessions
nslices = 42;                                                               % number of slices per EPI volume
TR = 2.4;                                                                  % TR in seconds
% folders = {'EPI1'; 'EPI2'; 'Fieldmap'; 'Structural'};                       % folders for analysis
folders = {'func'; 'anat'};
for sub = subs;                                                             % subject loop
    
    directories.sdir = sprintf('P%02d',sub);                                % subject specific directory
    
    %% build first-level model
   
    for ses = 1:sesnum
        imgs = spm_select('FPList',fullfile(directories.rdir,directories.sdir,folders{ses}),'^swar.*\.nii$');
        matlabbatch{1}.spm.stats.fmri_spec.sess(ses).scans = mat2cell(imgs,ones(size(imgs,1),1),size(imgs,2));

        matlabbatch{1}.spm.stats.fmri_spec.sess.cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(ses).multi = {fullfile(directories.rdir,directories.sdir,directories.wdir,'B08_S1.mat')};
        matlabbatch{1}.spm.stats.fmri_spec.sess(ses).regress = struct('name', {}, 'val', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(ses).multi_reg = {spm_select('FPList',fullfile(directories.rdir,directories.sdir,folders{ses}),'^rp.*\.txt$')};
        matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 100;
    end

    matlabbatch{1}.spm.stats.fmri_spec.dir = {fullfile(directories.rdir,directories.sdir,directories.wdir)};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = TR;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 42;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 21;
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

%% estimate model estimation
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
%constract manager

matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));

    %constract a
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'AW>AN';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    %constract e 
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'FW_M>FN_M';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 0 0 1 0 -1];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    %constract g  
matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Gain>no gain';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [0 0 3 -1 -1 -1];
matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0

spm_jobman('run', matlabbatch);
    end