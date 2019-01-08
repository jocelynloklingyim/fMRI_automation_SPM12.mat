# fMRI-MID-SPM.mat
These codes are for fMRI data analysis. 
These file consists of scripts for fMRI pre-processing, 1st level analysis and 2nd level analysis. I admit these scripts are not the most elegant and efficent ways, but it still saved me a lot of time compared to doing it by clicking on SPM! 


Instructions: 
To use these scripts for your analysis, make use you structure the your folder in the following steps:
1. create a folder called **'subs'**
2. create a folder for each of your subjects. name as 'Px', where x is the identification number for your subject. eg. P1, P2, P3.....
3. within each **'Px'** folder you create, make sure you have both the anatomy and functional scans of the subject.
4. rename the folder contains your anatomy scans as **'anat'**, and **'func'** for the functional images. Do it for all participants. 
5. 

## Pre-processing 
Download **preproc_JY.m**

To use this script for your pre-processing, make sure your change the following lines: 
1. Line 1: i = the number of the subject, which identical to the number of 'P' folder, for example, to analyse folder 'P1', put i = 1
2. line 4: change directory to where your 'subs' is located.
3. line 76: change directory to where your TPM.nii is located.
4. line 94: change directory to where your SPM is located on you computer. 


you have to change for each subject. Technically, it is feasible to write a loop so that SPM would analyse the scans of all participants in the folder without needing to change to subject number. Practically, however it is alwasys **Recommanded** to check the result of pre-processed images, and I would recommand you to do so after each run. 
