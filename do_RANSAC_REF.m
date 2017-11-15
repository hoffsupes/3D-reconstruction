
function [Pbestnew,final_inliers,R,T,W] = do_RANSAC_REF(X,c,P,k,eps,thresh,inlier_ratio,dshow) %% X: All the 3D data points, c: All the 2D data points, P: Probability that at least one of the subsets contains no outliers, k: size of subset, eps: fraction of outliers

s = log(1 - P) / log(1 - (1-eps).^(k) );				%% number of subsets 

inliers_max = 0;
Pbest = [];
Pbestnew = [];
lll = [];
l4 = [];
n = length(X);
i = 0;

while(i < s && (inliers_max / n) < inlier_ratio )
L1 = X; L2 = c;
% [Xn,l] = datasampl(L1,k,2,'Replace',false); %% test this on small samples 3D
l = randsample(n/2,k/2,false);
Xn = X(:,l);
Cn = c(:,l);            %% 2D
L1(:,l) = [];    %% points in c,r form, check
L2(:,l) = [];    %% points in c,r form, check

P = get_projection_linear(Xn,Cn);
Cnew = P * [L1; ones(1,length(L1))];
Cnew = Cnew ./ Cnew(3,:);
[ll,inliers] = do_dist_measure(Cnew(1:2,:),L2,thresh);

if(inliers > inliers_max) 
    Pbest = P;
    lll = ll;
    l4 = l;
    inliers_max = inliers;
end


if(dshow)
i
end


i = i + 1;
end

%%% Determining the inliers using the best transform
% 


% XN = X;
% CN = c;
% CNN = Pbest * [XN; ones(1,length(XN))];
% CNN = CNN ./CNN(3,:);
% [L,~] = do_dist_measure(CN,CNN(1:2,:),thresh);

%%% Best transform calculated using all the inliers
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
