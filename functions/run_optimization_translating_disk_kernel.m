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

function [out_map,out_fval,out_sobel] = run_optimization_translating_disk_kernel(patch_size,kersize,imglg,imgrg,imgcg,border,s,fig_flag)

[row,col]=size(imglg);
m=(patch_size-1)/2;
mids=(s-1)/2;

rowmax=m+1:s:row-m;
colmax=m+1:s:col-m;

% Initialize depth map, error, and sobel
out_map = zeros(row,col); 
out_fval = zeros(row,col);
out_sobel = zeros(row,col);

sb=[-1 0 1; -2 0 2; -1 0 1];

if(fig_flag)
figure, hold on
end

tot_time = 0;
disp_counter=1;
% loop over tiles
for i=m+1:s:row-m
    fprintf('%d of %d - ',disp_counter,length(m+1:s:row-m));
    tic;
    disp_counter=disp_counter+1;
    for j=m+1:s:col-m
        
        patlgo=imglg(i-m:i+m,j-m:j+m);
        patrgo=imgrg(i-m:i+m,j-m:j+m);
        patcgo=imgcg(i-m:i+m,j-m:j+m);
        
        sobel_val = conv2(patcgo,sb,'same');
        sobel_val=sobel_val(2:end-1,2:end-1);
        sobel_val = mean(abs(sobel_val(:)));


[ker_sig,~,fval]=solver_translating_disk_kernel(kersize,patlgo,patrgo,border);

out_map(i-mids:i+mids,j-mids:j+mids)=ker_sig;
out_fval(i-mids:i+mids,j-mids:j+mids)=fval;
out_sobel(i-mids:i+mids,j-mids:j+mids)=sobel_val;
if(fig_flag)
subplot(221), imshow(uint8(imglg(rowmax(1)-mids:rowmax(end)+mids,colmax(1)-mids:colmax(end)+mids,:))), title('Image');
subplot(222), imshow(out_map(rowmax(1)-mids:rowmax(end)+mids,colmax(1)-mids:colmax(end)+mids,:),[]), title('Coarse depth map');
subplot(223), imshow(1./out_fval(rowmax(1)-mids:rowmax(end)+mids,colmax(1)-mids:colmax(end)+mids,:),[]), title('Inverse of error');
subplot(224), imshow(out_sobel(rowmax(1)-mids:rowmax(end)+mids,colmax(1)-mids:colmax(end)+mids,:),[]), title('Sobel value');
drawnow;
end

    end
    ttt=toc;
    tot_time = tot_time + ttt;
    fprintf(' Time taken %f mins - Estimated time remaining %f mins \n',ttt/60,tot_time/(disp_counter-1)*(length(m+1:s:row-m)-disp_counter+1)/60);
end