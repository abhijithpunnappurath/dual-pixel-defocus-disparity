% Code taken from : http://kaiminghe.com/eccv10/
% Paper : Guided Image Filtering, ECCV10, TPAMI13

clc;
clear;
close all;

addpath(genpath('functions'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% user inputs start here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

directory_name = 'Results_qualitative';
img_name = '0001_p_111_k_41_s_33_r_0.5';
    
r = 10;
eps = 10^-6;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% user inputs end here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I = double(imread(fullfile(directory_name,img_name,'reference.png'))) / 255;
p = double(imread(fullfile(directory_name,img_name,'bilateral_solver_result.png'))) / 255;

tic;
q = guidedfilter_color(I, p, r, eps);
ttt=toc;
fprintf('Elapsed time %f sec \n',ttt);

q=(q-min(q(:)))/( max(q(:))-min(q(:)) );
q = ind2rgb(uint8(255*q), viridis(256));

imwrite(q,fullfile(directory_name,img_name,'output.png'))
