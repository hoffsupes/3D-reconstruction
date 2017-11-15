
function [Pbestnew,final_inliers] = do_RANSAC(X,c,P,k,eps,thresh,inlier_ratio) %% X: All the 3D data points, c: All the 2D data points, P: Probability that at least one of the subsets contains no outliers, k: size of subset, eps: fraction of outliers

s = log(1 - P) / log(1 - (1-eps).^(k) );				%% number of subsets 

inliers_max = 0;
Pbest = [];
Pbestnew = [];

n = length(X);
i = 0;

while(i < s || (inliers_max / n) < inlier_ratio )       %% if more than s
L1 = X; L2 = c;
% [Xn,l] = datasampl(L1,k,2,'Replace',false); %% test this on small samples 3D
l = randsample(n,k,false);
Xn = X(:,l);
Cn = c(:,l);            %% 2D
L1(:,l) = [];    %% points in c,r form, check
L2(:,l) = [];    %% points in c,r form, check

P = get_projection_linear(Xn,Cn);                   %% obtaining a projection
Cnew = P * [L1; ones(1,length(L1))];
Cnew = Cnew ./ Cnew(3,:);
[~,inliers] = do_dist_measure(Cnew(1:2,:),L2,thresh);       %% getting current no of inliers

if(inliers > inliers_max)                           %% if inliers are larger than some
    Pbest = P;
    inliers_max = inliers;                          %% set inliers_max to inliers and Pbest to P
end

i = i + 1;
end

%%% Determining the inliers using the best transform

XN = X;
CN = c;
CNN = Pbest * [XN; ones(1,length(XN))];         %% previous best transform
CNN = CNN ./CNN(3,:);
[L,~] = do_dist_measure(CN,CNN(1:2,:),thresh);  %% get inlier indices

%%% Best transform calculated using all the inliers
Pbestnew = get_projection_linear(X(:,L),c(:,L));    %% final transform

XN = X;
CN = c;

CNN = Pbestnew * [XN; ones(1,length(XN))];
CNN = CNN ./CNN(3,:);
[fin_pos,final_inliers] = do_dist_measure(CN,CNN(1:2,:),thresh);    %% final inliers

disp('outliers');
setdiff(1:length(X),find(fin_pos))

[R,T,W] = get_camera_para(Pbestnew)

end
