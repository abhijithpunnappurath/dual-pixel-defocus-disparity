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


function [x,ker_est,fval]=solver_translating_disk_kernel(kersize,patlg,patrg,border)

% do a simple SSD search to find direction of shift
% initializing in the right direction helps speed up the optimization
myflag=check_shift_direction(patlg,patrg);

options = optimoptions('fmincon','Display','off');
A=[];
b=[];
Aeq=[];
beq=[];
lb=-(kersize-1)/2;
ub=(kersize-1)/2;%Inf;
if(myflag==1)
x0=-1;
else
x0=1;
end
nonlcon=[];

[x,fval,~,~] = fmincon(@myfun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);
        
ker_est = ker_disk(x,kersize);

    function xerr=myfun(xe)

        h = ker_disk(xe,kersize);
        
        % only flipped kernel symmetry cost
        l=conv2(patlg,fliplr(h),'same');
        r=conv2(patrg,h,'same');
        
        l=l(border+1:end-border,border+1:end-border);
        r=r(border+1:end-border,border+1:end-border);
        
        err=(l-r)/255;
        xerr=sum(err(:).*err(:))/numel(err); 
        
%         fprintf('%f %f \n',xe,xerr);
    end

    function kerout = ker_disk(kersig,kersize)
        
        circ=fspecial('disk',abs(kersig));
        refcirc=zeros(kersize,kersize);
        radius=(size(circ,1)-1)/2;
        refcirc((kersize-2*radius+1)/2:kersize-(kersize-2*radius+1)/2+1, ...
                (kersize-2*radius+1)/2:kersize-(kersize-2*radius+1)/2+1)=circ;

        dist_array=linspace(0,2*radius+1,2*radius+1+1);
        diskker=zeros(kersize,kersize);
        for i=dist_array
            diskker=diskker+refcirc.*imtranslate(refcirc,[sign(kersig)*i 0]);
        end
        kerout=0.5*diskker./sum(diskker(:));

    end

end

