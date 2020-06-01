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

function [target,confidence,reference] = prep_for_step_two(imgc,out_map,out_fval,out_sobel,stride,patch_size,ker_size)

% currently, no handling of borders
[row,col,~]=size(imgc);
m=(patch_size-1)/2;
s=stride;
rowmax=m+1:s:row-m;
colmax=m+1:s:col-m;
mids=(s-1)/2;
imgc_crop=imgc(rowmax(1)-mids:rowmax(end)+mids,colmax(1)-mids:colmax(end)+mids,:);
out_map_crop=out_map(rowmax(1)-mids:rowmax(end)+mids,colmax(1)-mids:colmax(end)+mids,:);
% out_fval(out_fval==0)=eps; % some very small value
out_fval_crop=out_fval(rowmax(1)-mids:rowmax(end)+mids,colmax(1)-mids:colmax(end)+mids,:);
confidence_crop=exp(-1000000*out_fval_crop);
confidence_crop(out_map_crop+((ker_size-1)/2)<10^(-2))=0; % this may not matter so much
confidence_crop(((ker_size-1)/2)-out_map_crop<10^(-2))=0; % this may not matter so much
out_sobel_crop=out_sobel(rowmax(1)-mids:rowmax(end)+mids,colmax(1)-mids:colmax(end)+mids,:);
out_sobel_crop_n=out_sobel_crop./max(out_sobel_crop(:));

confidence_adj=confidence_crop.*out_sobel_crop_n;
confidence_adj=(confidence_adj-min(confidence_adj(:)))/(max(confidence_adj(:))-min(confidence_adj(:)));
confidence_adj(confidence_adj==0)=10^(-150); % some very small value
confidence=confidence_adj;
target=out_map_crop;
reference=imgc_crop;