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

function srcc = srcc_calc(dep1,dep2)

% first rank the depths
dep1vals=unique(dep1);
dep1rank=zeros(size(dep1));
for i=1:length(dep1vals)
    dep1rank(dep1==dep1vals(i))=i;
end

dep2vals=unique(dep2);
dep2rank=zeros(size(dep2));
for i=1:length(dep2vals)
    dep2rank(dep2==dep2vals(i))=i;
end

% now calculate Pearson's correlation coefficient
numeratorval = sum((dep1rank(:)-mean(dep1rank(:))).*(dep2rank(:)-mean(dep2rank(:))));
denominatorval = sqrt(sum((dep1rank(:)-mean(dep1rank(:))).^2)) * sqrt(sum((dep2rank(:)-mean(dep2rank(:))).^2));
srcc=1-abs(numeratorval/denominatorval);