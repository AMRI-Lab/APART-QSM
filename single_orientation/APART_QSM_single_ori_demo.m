% Demo of APART-QSM using single-orientation data

clear
clc

%% loading and setting

% save path
save_path = './results';	% please define the path to save results

% input
load('./single_orientation_data/mag_img.mat');          % magnitude image
load('./single_orientation_data/phi_local_img.mat');	% local phase image
load('./single_orientation_data/r2_img.mat');           % R2 map
load('./single_orientation_data/chi_img.mat');          % initial STAR-QSM image
load('./single_orientation_data/mask.mat');             % brain mask
load('./single_orientation_data/TEs.mat');              % echo time

% set mask
params.mask = mask;

% set parameters
params.size = size(mag_img(:,:,:,1));   % matrix size
params.voxel_size = [1, 1, 2];	% voxel size, unit: mm
params.n_echo = length(TEs);    % echo number
params.TEs = TEs;           % echo time, unit: s
params.gamma = 42.576;      % gyromagnetic ratio, unit: MHz/T
params.B0 = 3;              % B0 field, unit: T
params.B0_dir = [0, 0, 1];  % B0 direction
params.a = 323.5;           % magnitude decay kernel unit: Hz/ppm

% tolerance of the a-map relative change in two consecutive iterations
params.tol_a = 0.3;

% scaling weight
params.lambda_r2prime = 0.1;
params.lambda_chi = 10;
params.lambda_TV = 1;

%% exexcute APART-QSM
Res_map = apart_qsm_single_ori(mag_img, phi_local_img, r2_img, chi_img, params);

%% save results
if ~exist(save_path,'dir')
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




