% Demo of APART-QSM using multi-orientation data
%
% In this demo, five-orientation GRE data were provided for testing. all 
% orientation's complex GRE data have been registered to the first 
% orientation's magnitude image using FSL FLIRT (Jenkinson and Smith, 
% Medical Image Analysis, 2001). Five B0 directions were computed by the 
% corresponding rotation matrices from FLIRT.

clear
clc

%% loading and setting

% save path
save_path = './results';	% please define the path to save results

% input
load('./multi_orientation_data/r2_img.mat');            % R2 map
load('./multi_orientation_data/mask.mat');              % brain mask
load('./multi_orientation_data/TEs.mat');               % echo time
load('./multi_orientation_data/B0_dirs.mat');           % B0 directions

n_echo = 6;	% echo number      
n_ori = 5;	% orientation number
for iori = 1:n_ori
    idx = num2str(iori);
    load(['./multi_orientation_data/mag_img_ori',idx,'.mat']);          % magnitude image
    load(['./multi_orientation_data/phi_local_img_ori',idx,'.mat']);	% local phase image
end
% make sure the following images and parameters correspond to each other
% combine multi-orientation images
mag_img = cat(4, mag_img_ori1, ...
                 mag_img_ori2, ...
                 mag_img_ori3, ...
                 mag_img_ori4, ...
                 mag_img_ori5);
phi_local_img = cat(4, phi_local_img_ori1, ...
                       phi_local_img_ori2, ...
                       phi_local_img_ori3, ...
                       phi_local_img_ori4, ...
                       phi_local_img_ori5);             
% repeat echo time and B0 direction matching with the combined images
TEs = repmat(TEs, n_ori, 1);
B0_dirs = repelem(B0_dirs, n_echo, 1);

% set mask
params.mask = mask;

% set parameters
params.n_img = n_ori * n_echo;          % inputted image number
params.size = size(mag_img(:,:,:,1));   % matrix size
params.voxel_size = [1, 1, 2];          % voxel size, unit: mm
params.TEs = TEs;               % echo time
params.gamma = 42.576;          % gyromagnetic ratio, unit: MHz/T
params.B0 = 3;                  % B0 field, unit: T
params.B0_dirs = B0_dirs;       % B0 directions
params.a = 323.5;               % magnitude decay kernel unit: Hz/ppm
params.lambda_r2prime = 0.1;	% scaling weight of R2 related term

% tolerance of the a-map relative change in two consecutive iterations
params.tol_a = 0.3;

%% exexcute APART-QSM
Res_map = apart_qsm_multi_ori(mag_img, phi_local_img, r2_img, params);

%% save results
if ~exist(save_path, 'dir')
    mkdir(save_path);
end
save_nii(make_nii(single(Res_map(:,:,:,1)), params.voxel_size), fullfile(save_path,'X_para.nii'));
save_nii(make_nii(single(Res_map(:,:,:,2)), params.voxel_size), fullfile(save_path,'X_dia_abs.nii'));
save_nii(make_nii(single(Res_map(:,:,:,3)), params.voxel_size), fullfile(save_path,'phase_res.nii'));
save_nii(make_nii(single(Res_map(:,:,:,4)), params.voxel_size), fullfile(save_path,'a_map.nii'));
save_nii(make_nii(single(Res_map(:,:,:,5)), params.voxel_size), fullfile(save_path,'M0.nii'));
save_nii(make_nii(single(Res_map(:,:,:,6)), params.voxel_size), fullfile(save_path,'R2star.nii'));
save_nii(make_nii(single(Res_map(:,:,:,7)), params.voxel_size), fullfile(save_path,'R2prime.nii'));
save_nii(make_nii(single(Res_map(:,:,:,1) - Res_map(:,:,:,2)), params.voxel_size), fullfile(save_path,'X_composite.nii'));




