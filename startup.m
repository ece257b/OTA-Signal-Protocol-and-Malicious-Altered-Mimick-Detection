%%%%%%%%%%%
% Script to initialize pre-requisite matlab functions and objects
%%%%%%%%%%%

cd(fileparts(which(mfilename))) % switches to this files folder location
addpath(genpath('./')) % adds all folders and subfolders to path

text = sprintf('Adding all folders and subfolders in %s to MATLAB path', pwd);
disp(' ')
disp(text)
disp(' ')
