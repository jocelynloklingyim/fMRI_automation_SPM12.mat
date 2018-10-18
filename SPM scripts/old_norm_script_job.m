for i = 1
    
   
subs = [i]
directories.rdir = 'C:\CBD\MID_MRI\new-test';  % root directory
directories.wdir = 'subs';                                                  % directory where subject data kept
sesnum = 1;                                                                 % number of EPI sessions
nslices = 42;                                                               % number of slices per EPI volume
TR = 2.4;                                                                     % TR in seconds
folders = {'func'; 'anat'};                      % folders for analysis

for sub = subs;                                                             % subject loop
    
    directories.sdir = sprintf('P%02d',sub);                                % subject specific directory
    
    
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
    
    
    %% normalise structual to MNI-structural then normalise EPIs
    clear matlabbatch
    %%%
    matlabbatch{1}.spm.tools.oldnorm.estwrite.subj.source = {'C:\CBD\MID_MRI\new-test\subs\P01\anat\rsP01_S2.nii'};
matlabbatch{1}.spm.tools.oldnorm.estwrite.subj.wtsrc = '';
matlabbatch{1}.spm.tools.oldnorm.estwrite.subj.resample = 
{'spm_select('FPList',fullfile(directories.rdir,directories.wdir,directories.sdir,folders{end}),'^r.*\.nii$'))'

    'spm_select('FPList',fullfile(directories.rdir,directories.wdir,directories.sdir,folders{ses}),'^ar.*\.nii$')'

}

matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.template = {'C:\Users\ling9\Downloads\spm12\spm12\toolbox\OldNorm\T1.nii,1'};
matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.weight = '';
matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.smosrc = 8;
matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.smoref = 0;
matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.regtype = 'mni';
matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.cutoff = 25;
matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.nits = 16;
matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.reg = 1;
matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.preserve = 0;
matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.bb = [-78 -112 -70
                                                         78 76 85];
matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.vox = [3 3 3];
matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.interp = 1;
matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.prefix = 'w';

    
    %%% smoothing
    clear matlabbatch
    matlabbatch{1}.spm.spatial.smooth.data = {};
    for ses = 1:sesnum
        imgs = spm_select('FPList',fullfile(directories.rdir,directories.wdir,directories.sdir,folders{ses}),'^w.*\.nii$');
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
