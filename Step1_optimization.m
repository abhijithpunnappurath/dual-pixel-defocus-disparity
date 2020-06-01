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

addpath(genpath('functions'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% user inputs start here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

select_folder = 'Qualitative'; % input folder
save_path = 'Results_qualitative'; % results folder

imgname = '0035_B.tif'; % selected image
                        % should end with '_B.tif'
% Note:
% [imgname(1:end-6) '_L.TIF'] and [imgname(1:end-6) '_R.TIF'] are expected
% to be present inside select_folder

fig_flag=1; %0 -> no figure pop ups indicating progress

image_resize_val = 0.5; % downsample the image by this factor
                        % downsampling (or resampling) is generally NOT recommended
                        % since this can destroy dual-pixel disparity
                        % information. However, optimization applied
                        % patch-wise is very slow. This is a running time
                        % versus accuracy trade-off.
                        
patch_size = 111; %ALWAYS ODD, after resizing

ker_size = 41; %ALWAYS ODD, size of the kernel. 
              %  Make sure kernel is big enough. If selected image has patches with
              %  too much blur, then kernel size should be adjusted accordingly. 
              
stride = 33; % ALWAYS ODD, 
                   % the bigger this number, the faster the algorithm, and
                   % the coarser the output map

border = 25; % border pixels to leave out during optimization cost computation
           % should be greater than half of kernel size

           
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% user inputs end here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


extraval = ['_p_' num2str(patch_size) '_k_' num2str(ker_size) '_s_' num2str(stride) '_r_' num2str(image_resize_val)];
fprintf('%s \n',fullfile(select_folder,[imgname(1:end-6) extraval]))
    
% read left and right images
imgl=imread(fullfile(select_folder,[imgname(1:end-6) '_L.TIF']));
imgr=imread(fullfile(select_folder,[imgname(1:end-6) '_R.TIF']));
% and the combined image
imgc=imread(fullfile(select_folder,imgname));

% resize the images
imgl = imresize(imgl,image_resize_val,'bicubic');
imgr = imresize(imgr,image_resize_val,'bicubic');
imgc = imresize(imgc,image_resize_val,'bicubic');

% convert to grayscale
imgcg=double(rgb2gray(imgc));
imglg=double(rgb2gray(imgl));
imgrg=double(rgb2gray(imgr));

% run optimization algorithm
[out_map,out_fval,out_sobel] = run_optimization_translating_disk_kernel(patch_size,ker_size,imglg,imgrg,imgcg,border,stride,fig_flag);

% compute confidenc map and save results in a manner suited to run Step 2 
% which is the bilateral solver
[target,confidence,reference] = prep_for_step_two(imgc,out_map,out_fval,out_sobel,stride,patch_size,ker_size);

% save for Step 2
mkdir(fullfile(save_path,[imgname(1:end-6) extraval]))
imwrite(confidence,fullfile(save_path,[imgname(1:end-6) extraval '/confidence.png'])); % just for display
target=(target-min(target(:)))/(max(target(:))-min(target(:)));
imwrite(uint8(target*255),fullfile(save_path,[imgname(1:end-6) extraval '/target.png'])); % just for display
imwrite(reference,fullfile(save_path,[imgname(1:end-6) extraval '/reference.png']))
save(fullfile(save_path,[imgname(1:end-6) extraval '/res.mat']),'target','confidence'); % used in Step 2

fprintf('\nFinished execution \n \n');
fprintf('In Steps 2 and 3, \nuse directory_name = ''%s'' \nand img_name = ''%s''\n',save_path,[imgname(1:end-6) extraval]);