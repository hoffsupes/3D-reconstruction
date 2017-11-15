
function match_LR_points(rect_LI,rect_RI,Ltforms,Rtforms,k)

crli = imresize(rect_LI,k); 
crlizero = imresize(Ltforms,k);

crri = imresize(rect_RI,k); 
crrizero = imresize(Rtforms,k);

[I J] = find(crlizero); newpts1 = [I J]; I = []; J = [];
[I J] = find(crrizero); newpts2 = [I J];

[feat1,vp1] = extractFeatures(rgb2gray(crli),newpts1);
[feat2,~] = extractFeatures(rgb2gray(crri),newpts2);
iP = matchFeatures(feat1,feat2);
pptnew = vp1(iP(:,1),:);

LL = ones(round((1/k)*size(rect_LI,1)),round((1/k)*size(rect_LI,2)),1);
[II JJ] = find(LL);
lpts = [II JJ];
calc_lpts = [JJ II ones(size(lpts,1),1)]';
zpk = [k 0 0; 0 k 0; 0 0 1]*calc_lpts;
zpk = zpk ./ zpk(3,:);
zpk(3,:) = [];
zpk = round(zpk)';

imshow(rect_LI); hold on;

for i = 1:size(pptnew,1)
pop = lpts(zpk(:,2) == pptnew(i,1) & zpk(:,1) == pptnew(i,2),:);
scatter(pop(:,2),pop(:,1)); hold on;
end

end