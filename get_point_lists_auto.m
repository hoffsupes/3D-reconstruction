function [dispty1,dispty2,matches,Lpts,bmap,dispr] = get_point_lists_auto(LI,RI,Lzero,Rzero,rect_LI,rect_RI,WL,WR,n,padr,k,wsize,kksiz)

if(mod(wsize,2) == 0) wsize = wsize - 1; end
halfwsize = floor(wsize/2);

dispty1 = zeros(size(Lzero));
dispty2 = zeros(size(Lzero));

Ltforms = 255*uint8(uint8(get_btform(Lzero,WL,n))~=0); Ltforms = padarray(Ltforms,[padr padr]);
Rtforms = 255*uint8(uint8(get_btform(Rzero,WR,n))~=0); Rtforms = padarray(Rtforms,[padr padr]);
bmap = zeros(size(Ltforms));

rows = size(Rtforms,1);
cols = size(Rtforms,2);

[I,J] = find(Ltforms); Lpts = [I J]; I = []; J = [];
[I,J] = ind2sub(size(Rtforms),find(Rtforms)); Rpts = [I J];

rlgray = rgb2gray(rect_LI);
rrgray = rgb2gray(rect_RI);


dispr = zeros(size(Lpts,1),1);
matches = zeros(size(Lpts));

[Lpts,matches] = do_auto_matching(Lpts,Rpts,rlgray,rrgray);

calc_lpts = [Lpts(:,2)-padr Lpts(:,1)-padr ones(length(Lpts),1)]';
zpk = inv(WL)*calc_lpts;
zpk = zpk ./ zpk(3,:);
zpk(3,:) = [];
zpk = round(zpk)';

disp('All the points done!!');

dispty1(sub2ind(size(dispty1),zpk(:,2),zpk(:,1))) = dispr(1:size(zpk,1));

bmap(sub2ind(size(bmap),Lpts(:,1),Lpts(:,2))) = dispr(1:size(Lpts,1));
% lmap = bmap(15:347,217:end-10);
dispty2 = get_btform_forward(Lzero,bmap,WL,n,padr);
% imshow(medfilt2(lmap,[5 5]),[min(min(lmap)),max(max(lmap))]);
disp('Created disparity matrix!');

end