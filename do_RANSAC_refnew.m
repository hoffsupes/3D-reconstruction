
function [Pbestnew,final_inliers,R,T,W] = do_RANSAC_refnew(X,c,P,k,eps,thresh,inlier_ratio,dshow,LRthresh) %% X: All the 3D data points, c: All the 2D data points, P: Probability that at least one of the subsets contains no outliers, k: size of subset, eps: fraction of outliers

s = log(1 - P) / log(1 - (1-eps).^(k) )				%% number of subsets 

inliers_max = 0;
Pbest = [];
Pbestnew = [];
lll = [];
l4 = [];
n = length(X);
i = 0;

pts2 = c(1,:) < LRthresh;
pts1 = ~pts2;
P1X = X(:,pts1); P1c = c(:,pts1); n1 = length(P1X);
P2X = X(:,pts2); P2c = c(:,pts2); n2 = length(P2X);
zpos1 = find(pts1);
zpos2 = find(pts2);

while(i < s)

% [Xn,l] = datasampl(L1,k,2,'Replace',false); %% test this on small samples 3D
l1 = randsample(n1,k/2,false);
l2 = randsample(n2,k/2,false);

Xn = [P1X(:,l1) P2X(:,l2)];
Cn = [P1c(:,l1) P2c(:,l2)];
            
L1 = [P1X(:,setdiff(1:n1,l1)) P2X(:,setdiff(1:n2,l2))];
L2 = [P1c(:,setdiff(1:n1,l1)) P2c(:,setdiff(1:n2,l2))];

P = get_projection_linear(Xn,Cn);
Cnew = P * [L1; ones(1,length(L1))];
Cnew = Cnew ./ Cnew(3,:);
Cnew(3,:) = [];
[L,inliers] = do_dist_measure(Cnew,L2,thresh);

if(inliers > inliers_max) 
    Pbest = P;
    inliers_max = inliers;
    
    ltem = [zpos1(setdiff(1:n1,l1)) zpos2(setdiff(1:n2,l2))];
    lll = ltem(L);
    l4 = [zpos1(l1) zpos2(l2)];
    
end


i = i + 1;
end

Pbestnew = get_projection_linear(X(:,union(find(lll),l4)),c(:,union(find(lll),l4)));

XN = X;
CN = c;

CNN = Pbestnew * [XN; ones(1,length(XN))];
CNN = CNN ./CNN(3,:);
[fin_pos,final_inliers] = do_dist_measure(CN,CNN(1:2,:),thresh);

Pbestnew = get_projection_linear(X(:,fin_pos),c(:,fin_pos));

XN = X;
CN = c;

CNN = Pbestnew * [XN; ones(1,length(XN))];
CNN = CNN ./CNN(3,:);
[fin_pos,final_inliers] = do_dist_measure(CN,CNN(1:2,:),thresh);

disp('outliers');
setdiff(1:length(X),find(fin_pos))

[R,T,W] = get_camera_para(Pbestnew);

end
