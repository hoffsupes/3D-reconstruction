function [del_p1,del_p2] = get_eps_p1_p2(X,c,p1,p2,p3,p14,p24,p34,lam2)
 
% XE = [p1 p14; p2 p24; p3 p34] * [X; ones(1,length(X))]; %% check, X c in c,r form
% 
% X1 = XE(1,:)./ XE(3,:);
% X2 = XE(2,:)./ XE(3,:);
% 
% X1a = X1 - c(1,:);
% X1b = X./ XE(3,:); %% check
% 
% X2a = X2 - c(2,:);
% X2b = X./ XE(3,:); %% check
% 
% del_p1 = sum(X1a.*X1b.*2,2)' + lam2*((cross(p2,p3))*cross(repmat(p3',[1,3]),eye(3),1));
% del_p2 = sum(X2a.*X2b.*2,2)' + lam2*((cross(p1,p3))*cross(repmat(p3',[1,3]),eye(3),1));

del_p1 = 0;
del_p2 = 0;

for i = 1:length(X)

    del_p1 = del_p1 + -(2*X(:,i)*(c(1,i) - (p14 + p1*X(:,i))/(p34 + p3*X(:,i))))/(p34 + p3*X(:,i));
    del_p2 = del_p2 + -(2*X(:,i)*(c(2,i) - (p24 + p2*X(:,i))/(p34 + p3*X(:,i))))/(p34 + p3*X(:,i));
    
end
    
    del_p1 = del_p1 + lam2*(cross(repmat(p3',[1,3]),eye(3),1)*(cross(p2,p3))');
    del_p2 = del_p2 + lam2*(cross(repmat(p3',[1,3]),eye(3),1)*(cross(p1,p3))');

%%% del is a vector
end