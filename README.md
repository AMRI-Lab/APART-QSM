# APART-QSM: iterative magnetic susceptibility sources separation

APART-QSM is a new proposed QSM separation method using an iterative data fitting scheme.

APART-QSM can separate paramagnetic and diamagnetic susceptibility components on *in vivo* and *ex vivo* data.

APART-QSM can handle an arbitrary number of complex GRE data input measurements to provide high-quality QSM separation maps with more faithful tissue delineation of the small brain sub-regions.

This repository contains two implementations of APART-QSM method based on single-orientation and multiple orientation data.

## Reference

Li, Z., Feng, R., Liu, Q., Feng, J., Lao, G., Zhang, M., ... & Wei, H. (2023). APART-QSM: An improved sub-voxel quantitative susceptibility mapping for susceptibility source separation using an iterative data fitting method. *Neuroimage*, *274*, 120148.

## Required Dependencies

1. [STI_Suite V3.0 toolbox](https://people.eecs.berkeley.edu/~chunlei.liu/software.html) 

   preprocessing on phase data and QSM initialization

2. Nifti toolbox 

   saving reconstruction results

3. [FSL](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki) 

   brain mask generation and registration for multi-orientation data

## Usage

Recommended MATLAB version: R2019a, R2020a 

APART_QSM_single_ori_demo.m is a demo for susceptibility separation using single orientation data.

APART_QSM_multi_ori_demo.m is a demo for susceptibility separation using multiple orientation data.

For data acquired with 3D multi-echo GRE sequences, you should do the following preprocessing steps before running STI reconstruction codes in this repository:

(1) Extract the tissue mask from magnitude images using FSL Bet.

(2) Unwrap the raw phase data using Laplacian-based phase unwrapping in STI_Suite V3.0 toolbox.

(3) Divide the background and local phase using VSHARP in STI_Suite V3.0 toolbox.

(4) Co-register the magnitude images at different orientations to a reference orientation (supine position) using FSL FLIRT.

(5) Apply the transform matrix to the corresponding local phase and calculate magnetic field direction (obtain B0_dirs).

(6) Once the above steps are completed, you can run demos successfully as long as Nifti toolbox is installed and added to the path.

## License

Suspend license issuance temporarily.
