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

function [aiwe2,a,b] = aiwe2_calc(img1,img2)

A=[img1(:) ones(numel(img1),1)];
b=img2(:);
x=A\b;
img3=x(1)*img1+x(2);
aiwe2=rmse_calc(img3,img2);
a=x(1);
b=x(2);