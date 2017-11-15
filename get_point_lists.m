function [dispty1,dispty2,matches,Lpts,bmap,dispr] = get_point_lists(LI,RI,Lzero,Rzero,rect_LI,rect_RI,WL,WR,n,padr,k,wsize,kksiz,tr)

if(mod(wsize,2) == 0) wsize = wsize - 1; end
halfwsize = floor(wsize/2);

dispty1 = zeros(size(Lzero));
dispty2 = zeros(size(Lzero)); %% disparity in alternate form

Ltforms = 255*uint8(uint8(get_btform(Lzero,WL,n))~=0); Ltforms = padarray(Ltforms,[padr padr]); %% mask rectified, transforms also applied
Rtforms = 255*uint8(uint8(get_btform(Rzero,WR,n))~=0); Rtforms = padarray(Rtforms,[padr padr]);
bmap = zeros(size(Ltforms));

rows = size(Rtforms,1);
cols = size(Rtforms,2);

[I,J] = find(Ltforms); Lpts = [I J]; I = []; J = [];            %% points extracted
[I,J] = ind2sub(size(Rtforms),find(Rtforms)); Rpts = [I J];

rlgray = adapthisteq(rgb2gray(rect_LI));            %% adaptive histogram equalization
rrgray = adapthisteq(rgb2gray(rect_RI));


dispr = zeros(size(Lpts,1),1);      %% disparity 
matches = zeros(size(Lpts));        %% matches
k4 = 0.75;

size(Lpts,1)
t1 = clock;
i = 1;

while i <= size(Lpts,1)

%     i
%     size(Lpts,1)
    
    
    if(i > size(Lpts,1))
    break;
    end

    colind = [repmat(1:cols,[(2*k +1),1])];
    rowind = repmat([Lpts(i,1)-k:Lpts(i,1)+k]',[1,cols]);       %% select k rows from right image
    fin_ind = [rowind(:) colind(:)];
    
    trav_m = (Rtforms(sub2ind(size(Rtforms),fin_ind(:,1),fin_ind(:,2))) ~= 0);      %% select those points in right which are on the image
    
    if(nnz(trav_m) == 0)
    Lpts(i,:) = [];
    matches(i,:) = [];
    dispr(i,:) = [];
    continue;
    end
    
    fin_ind = fin_ind(trav_m,:);        %% keep only those points out of the k rows which belong to the rectified image
    ssd_score = zeros(size(fin_ind,1),1);
%     cc_R = zeros(size(fin_ind,1),1);
%     cc_B = zeros(size(fin_ind,1),1);
%     cc_G = zeros(size(fin_ind,1),1);
    cc_A = zeros(size(fin_ind,1),1);            %% Disparity of grayscale values
    
    p1 = fin_ind(:,1) + [-halfwsize:halfwsize];     %% construct indice lists which generate windows as submatrices
    p2 = fin_ind(:,2) + [-halfwsize:halfwsize];
    
    p3 = Lpts(i,1) + [-halfwsize:halfwsize];
    p4 = Lpts(i,2) + [-halfwsize:halfwsize];
    
    Wleft = rlgray(p3,p4);              %% Wleft created out of grayscale images
    
    for j = 1:size(fin_ind,1)
    
    Wright = rrgray(p1(j,:),p2(j,:));    %% Wright
    ssd_score(j) = sum(sum( (Wleft - Wright).^2 ));  %% ssd value calculated
%     cc_R(j) = corr2(rect_LI(p1(j,:),p2(j,:),1),rect_RI(p1(j,:),p2(j,:),1));    
%     cc_G(j) = corr2(rect_LI(p1(j,:),p2(j,:),2),rect_RI(p1(j,:),p2(j,:),2));    
%     cc_B(j) = corr2(rect_LI(p1(j,:),p2(j,:),3),rect_RI(p1(j,:),p2(j,:),3));    
%     cc_A(j) = corr2(rlgray(p3,p4),rrgray(p1(j,:),p2(j,:)));    
    
    end
    
%     if(nnz(ssd_score) == length(ssd_score))
%     
% %         frintf('\nPts with nonzero scores exist! \n');
%         Lpts(i,:) = [];
%         matches(i,:) = [];
%         dispr(i,:) = [];
%         continue;
%     end

%     votes = (cc_A > k4) + (cc_B > k4) + (cc_G > k4) + (cc_R > k4);
    seclar = max(cc_A(cc_A<max(cc_A)));
    
    if((nnz((cc_A) > kksiz) == 0) & ( (seclar/max(cc_A)) > tr ) )
        
%         fprintf('\nPts with zero votes exist! \n');
        Lpts(i,:) = [];
        matches(i,:) = [];
        dispr(i,:) = [];
        continue;
        
    end
    
%     vlat = arrayfun(@(indv)find(votes == indv), unique(votes), 'UniformOutput',false);
%     mmvv = max(votes);  
%     
%     if(size(vlat{2},1) > 1 && unique(votes(vlat{2})) == mmvv)
%    
%     vm = find(votes);
%     [~,pos] = max(cc_A(vm));
%     minpos = vm(pos);
%    
%     else
%     [~,minpos] = max(votes);    
%     end
    
%     fmask = ssd_score == 0;
%     if(fmask(minpos) == 0)
%             
%         frintf('\nPts with zero matches exist! \n');
%         Lpts(i,:) = [];
%         matches(i,:) = [];
%         dispr(i,:) = [];
%         i = i - 1;
%         continue;
%        
%     end

    [~,minpos] = min(ssd_score);

    matches(i,:) = fin_ind(minpos,:);
    dispr(i) = Lpts(i,2) - fin_ind(minpos,2);       %% disparity value calculated

    if(mod(i,100) == 0)
    t2 = clock;
    l = (size(Lpts,1) - i) * etime(t2,t1) / 100;
    fprintf('\n %f percent complete: ',(i/size(Lpts,1))*100);
    fprintf('Approximate time to completion: %f mins.',l/60);
    
    t1 = t2;
    end
i = i + 1;
end

size(Lpts,1)

calc_lpts = [Lpts(:,2)-padr Lpts(:,1)-padr ones(length(Lpts),1)]';
zpk = inv(WL)*calc_lpts;
zpk = zpk ./ zpk(3,:);
zpk(3,:) = [];
zpk = round(zpk)';      %% convert Lpts to original coordinate system

disp('All the points done!!');

dispty1(sub2ind(size(dispty1),zpk(:,2),zpk(:,1))) = dispr(1:size(zpk,1));       %% disparity 

bmap(sub2ind(size(bmap),Lpts(:,1),Lpts(:,2))) = dispr(1:size(Lpts,1));      %% disparity values
% lmap = bmap(15:347,217:end-10);
dispty2 = get_btform_forward(Lzero,bmap,WL,n,padr);
% imshow(medfilt2(lmap,[5 5]),[min(min(lmap)),max(max(lmap))]);
disp('Created disparity matrix!');

end