%% experiment specific information

subs = [9]; %write in the subs you want to use!
directories.rdir = 'C:\CBD\MID_MRI\MRI B\subs';     % root directory
directories.wdir = 'FirstLevel';               % directory where subject data kept
%directories.adir = 'C:\CBD\MID_MRI\SecondLevel\subs\P01';                  % directory where analysis to be saved - I think this needs to be improved
sesnum = 1;                                                                 % number of EPI sessions
nslices = 42;                                                               % number of slices per EPI volume
TR = 2.4;                                                                  % TR in seconds
% folders = {'EPI1'; 'EPI2'; 'Fieldmap'; 'Structural'};                       % folders for analysis
folders = {'func'; 'anat'};
for sub = subs;                                                             % subject loop
    
    directories.sdir = sprintf('P%02d',sub);                                % subject specific directory
    
    %% build first-level model
    spm_get_defaults('mask.thresh',0.2);
    clear matlabbatch
    for ses = 1:sesnum
        imgs = spm_select('FPList',fullfile(directories.rdir,directories.sdir,folders{ses}),'^swar.*\.nii$');
        matlabbatch{1}.spm.stats.fmri_spec.sess(ses).scans = mat2cell(imgs,ones(size(imgs,1),1),size(imgs,2));
        matlabbatch{1}.spm.stats.fmri_spec.sess(ses).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(ses).multi = {fullfile(directories.rdir,directories.sdir,directories.wdir,'B09_S2.mat')};
        matlabbatch{1}.spm.stats.fmri_spec.sess(ses).regress = struct('name', {}, 'val', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(ses).multi_reg = {spm_select('FPList',fullfile(directories.rdir,directories.sdir,folders{ses}),'^rp.*\.txt$')};
        matlabbatch{1}.spm.stats.fmri_spec.sess(ses).hpf = 128;
    end
    
    
    matlabbatch{1}.spm.stats.fmri_spec.dir = {fullfile(directories.rdir,directories.sdir,directories.wdir)};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = TR;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    
    spm_jobman('run', matlabbatch);
    
    %% estimate first-level model
    clear matlabbatch
    matlabbatch{1}.spm.stats.fmri_est.spmmat = {fullfile(directories.rdir,directories.sdir,directories.wdir,'SPM.mat')};
    matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
    spm_jobman('run', matlabbatch);
    
    %% contrasts
    clear matlabbatch
    matlabbatch{1}.spm.stats.con.spmmat = {fullfile(directories.rdir,directories.sdir,directories.wdir,'SPM.mat')};
        %constracts a
    tcon.name = 'Anti_w>Anti_n';
    tcon.convec = [1 -1 0 0 0 0];
    tcon.sessrep = 'none';
    matlabbatch{1}.spm.stats.con.consess{1}.tcon = tcon;
    matlabbatch{1}.spm.stats.con.delete = 1;
        %constracts b 
    tcon.name = 'FW_H>FW_M';
    tcon.convec = [0 0 1 -1 0 0];
    tcon.sessrep = 'none';
    matlabbatch{1}.spm.stats.con.consess{2}.tcon = tcon;
    matlabbatch{1}.spm.stats.con.delete = 1;
   
        %constracts c
    tcon.name = 'FW_H>FN_H';
    tcon.convec = [0 0 1 0 -1 0];
    tcon.sessrep = 'none';
    matlabbatch{1}.spm.stats.con.consess{3}.tcon = tcon;
    matlabbatch{1}.spm.stats.con.delete = 1;
    
         %constracts d Anti_w' 'Anti_n' 'FW_h' 'FW_M' 'FN_H' 'FN_M
    tcon.name = 'FN_H>FN_M';
    tcon.convec = [0 0 0 0 -1 1];
    tcon.sessrep = 'none';
    matlabbatch{1}.spm.stats.con.consess{4}.tcon = tcon;
    matlabbatch{1}.spm.stats.con.delete = 1;

            %constracts e
    tcon.name = 'FW_M>FN_M';
    tcon.convec = [0 0 0 1 0 -1];
    tcon.sessrep = 'none';
    matlabbatch{1}.spm.stats.con.consess{5}.tcon = tcon;
    matlabbatch{1}.spm.stats.con.delete = 1;
   

    spm_jobman('run', matlabbatch);
end  %end subject loop
    