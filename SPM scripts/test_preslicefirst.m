for i = 1
    
   
subs = [i]
directories.rdir = 'C:\CBD\MID_MRI\new-test';  % root directory
directories.wdir = 'subs';                                                  % directory where subject data kept
sesnum = 1;                                                                 % number of EPI sessions
nslices = 42;                                                               % number of slices per EPI volume
TR = 2.4;                                                                     % TR in seconds
folders = {'func'; 'anat'};                      % folders for analysis

for sub = subs;                                                             % subject loop
    
    directories.sdir = sprintf('P%02d',sub);                                % subject specific directoryxxxxxxx
    
    
    %% realign, unwarp & reslice EPI images
    clear matlabbatch
    for ses = 1:sesnum
        imgs = spm_select('FPList',fullfile(directories.rdir,directories.wdir,directories.sdir,folders{ses}),'\.nii$');
        matlabbatch{1}.spm.spatial.realign.estwrite.data{ses} = mat2cell(imgs,ones(size(imgs,1),1),size(imgs,2));        
    end
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 4;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 0;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.einterp = 2;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.ewrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 1];
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
    spm_jobman('run', matlabbatch);
    
    %% Coregister structural to mean EPI
    
    clear matlabbatch
    
    matlabbatch{1}.spm.spatial.coreg.estwrite.ref = {spm_select('FPList',fullfile(directories.rdir,directories.wdir,directories.sdir,folders{1}),'^mean.*\.nii$')};
    matlabbatch{1}.spm.spatial.coreg.estwrite.source ={spm_select('FPList',fullfile(directories.rdir,directories.wdir,directories.sdir,folders{end}),'\.nii$')};
    matlabbatch{1}.spm.spatial.coreg.estwrite.other = {''};
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 4;
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';
    spm_jobman('run', matlabbatch);

    
    %% slice time correction
    clear matlabbatch
    for ses = 1:sesnum
        imgs = spm_select('FPList',fullfile(directories.rdir,directories.wdir,directories.sdir,folders{ses}),'^r.*\.nii$');
        matlabbatch{1}.spm.temporal.st.scans{ses} = mat2cell(imgs,ones(size(imgs,1),1),size(imgs,2));
    end
    matlabbatch{1}.spm.temporal.st.nslices = nslices;                   % set number of slices per EPI volume here
    matlabbatch{1}.spm.temporal.st.tr = TR;                             % set TR here
    matlabbatch{1}.spm.temporal.st.ta = TR-(TR/nslices);                % TR-(TR/nslices)
    matlabbatch{1}.spm.temporal.st.so = [1:nslices];
    matlabbatch{1}.spm.temporal.st.refslice = round(nslices/2);
    matlabbatch{1}.spm.temporal.st.prefix = 'a';
    spm_jobman('run', matlabbatch);
    %% Segmentation
    matlabbatch{1}.spm.spatial.preproc.channel.vols = {spm_select('FPList',fullfile(directories.rdir,directories.wdir,directories.sdir,folders{end}),'^s.*\.nii$')};
    matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
    matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
matlabbatch{1}.spm.spatial.preproc.channel.write = [0 1];
matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {'C:\Users\ling9\Downloads\spm12\spm12\tpm\TPM.nii,1'};
matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {'C:\Users\ling9\Downloads\spm12\spm12\tpm\TPM.nii,2'};
matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {'C:\Users\ling9\Downloads\spm12\spm12\tpm\TPM.nii,3'};
matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {'C:\Users\ling9\Downloads\spm12\spm12\tpm\TPM.nii,4'};
matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {'C:\Users\ling9\Downloads\spm12\spm12\tpm\TPM.nii,5'};
matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {'C:\Users\ling9\Downloads\spm12\spm12\tpm\TPM.nii,6'};
matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
matlabbatch{1}.spm.spatial.preproc.warp.write = [0 1];

    
    
  %% normalise structual to MNI-structural then normalise EPIs %%%JY
        clear matlabbatch
    matlabbatch{1}.spm.spatial.normalise.write.subj.def = {spm_select('FPList',fullfile(directories.rdir,directories.wdir,directories.sdir,folders{end}),'^y.*\.nii$')};
    matlabbatch{1}.spm.spatial.normalise.write.subj.resample = {spm_select('FPList',fullfile(directories.rdir,directories.wdir,directories.sdir,folders{1}),'^ar.*\.nii$')};
    matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                          78 76 85];
    matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = [3 3 3];
    matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;
    matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'w';  
        
   %% smoothing
    clear matlabbatch
    matlabbatch{1}.spm.spatial.smooth.data = {};
    for ses = 1:sesnum
        imgs = spm_select('FPList',fullfile(directories.rdir,directories.wdir,directories.sdir,folders{ses}),'^war.*\.nii$');
        imgs = mat2cell(imgs,ones(size(imgs,1),1),size(imgs,2));
        for vol = 1:length(imgs)
            matlabbatch{1}.spm.spatial.smooth.data{end+1,1} = imgs{vol};
        end
    end
    matlabbatch{1}.spm.spatial.smooth.fwhm = [6 6 6];
    matlabbatch{1}.spm.spatial.smooth.dtype = 0;
    matlabbatch{1}.spm.spatial.smooth.im = 0;
    matlabbatch{1}.spm.spatial.smooth.prefix = 's';
    spm_jobman('run', matlabbatch);

end  
end

clear