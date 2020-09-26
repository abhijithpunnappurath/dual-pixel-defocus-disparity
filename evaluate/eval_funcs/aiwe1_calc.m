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

function aiwe1 = aiwe1_calc(img1,img2)

A=[img1(:) ones(numel(img1),1)];
b=img2(:);
W=spdiags(ones(numel(img1),1),0,numel(img1),numel(img1));
x=(A'*W*A)\(A'*W*b);

for i=1:5
      e=abs(A*x-b);
      e=max(e,0.001).^(1-2);                    
      W=spdiags(e,0,numel(img1),numel(img1));
      x=(A'*W*A)\(A'*W*b);
end

img3=x(1)*img1+x(2);
aiwe1=mae_calc(img3,img2);