% # =============================================================================
% # @INPROCEEDINGS{punnappurath2020modeling,
% # author={Abhijith Punnappurath and Abdullah Abuolaim and Mahmoud Afifi and Michael S. Brown},
% # booktitle={IEEE International Conference on Computational Photography (ICCP)}, 
% # title={Modeling Defocus-Disparity in Dual-Pixel Sensors}, 
% # year={2020}}
% #
% # Author: Abhijith Punnappurath (05/2020)
% # pabhijith@eecs.yorku.ca
% # jithuthatswho@gmail.com
% # https://abhijithpunnappurath.github.io
% # =============================================================================

clc;
clear;
close all;

addpath(genpath('eval_funcs'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% user inputs start here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gt = imread('gt.TIF');
est = imread('est.TIF');

% currently, the code Step1_optimization.m does not handle borders
% so crop ground truth such that it matches the estimated result

% IMPORTANT:
% below, use same values as in Step1_optimization.m on lines 36 to 49
% to ensure proper alignment between gt and est
image_resize_val=0.5;
patch_size = 111;
stride = 33; 

border = 100; % optionally, remove some extra border pixels from both gt and est

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% user inputs end here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


gt = imresize(gt,image_resize_val,'bicubic');
   
[row,col]=size(gt);
m=(patch_size-1)/2;
s=stride;
rowmax=m+1:s:row-m;
colmax=m+1:s:col-m;
mids=(s-1)/2;
gt_crop=gt(rowmax(1)-mids:rowmax(end)+mids,colmax(1)-mids:colmax(end)+mids,:);

gt_crop=im2double(gt_crop(border+1:end-border,border+1:end-border));
est_crop=im2double(est(border+1:end-border,border+1:end-border));

aiwe1val = aiwe1_calc(est_crop,gt_crop);

[aiwe2val,a,b] = aiwe2_calc(est_crop,gt_crop);

srcc_array_val = srcc_calc(est_crop,gt_crop);

fprintf('%.3f %.3f %.3f \n',aiwe1val,aiwe2val,srcc_array_val);    
