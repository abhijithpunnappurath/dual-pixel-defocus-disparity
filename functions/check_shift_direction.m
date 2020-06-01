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

function myflag=check_shift_direction(img1,img2)

[~,col]=size(img1);
if(mod(col,4)==1)
    img1=img1(:,2:end);
    img2=img2(:,2:end);
    col=col-1;
elseif(mod(col,4)==2)
    img1=img1(:,3:end);
    img2=img2(:,3:end);
    col=col-2;
elseif(mod(col,4)==3)
    img1=img1(:,4:end);
    img2=img2(:,4:end);
    col=col-3;  
end
win=col/2;
r=col/4;
ssd_mat=zeros(1,win+1);

for j=1:win+1
    ssd_mat(1,j) = sum(sum( (img1(:,r+1:end-r)-img2(:,j:j+win-1)).^2  ));   
end


        % find min value
        [~,ind]=min(ssd_mat);
        
        if(ind>win/2+1)
        myflag=1;        
        else
        myflag=0;
        end
        
        