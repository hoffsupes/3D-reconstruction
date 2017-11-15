function del = get_eps_p3(X,c,p1,p2,p3,p14,p24,p34,lam1,lam2)

% XE = [p1 p14; p2 p24; p3 p34] * [X; ones(1,length(X))]; %% check, X c in c,r form
% 
% X1 = XE(1,:)./ XE(3,:);
% X2 = XE(2,:)./ XE(3,:);
% 
% X1a = X1 - c(1,:);
% X1b = X.*(-X1 ./ XE(3,:)); %% check
% 
% X2a = X2 - c(2,:);
% X2b = X.*(-X2 ./ XE(3,:)); %% check
% 
% del = (sum(X1a.*X1b.*2 + X2a.*X2b.*2,2))' + 2*lam1*p3 + lam2*( (cross(p2,p3))*cross(repmat(p1',[1,3]),eye(3),1) + (cross(p1,p3))*(cross(repmat(p2',[1,3]),eye(3),1)));
%%% del is a vector


del = 0;


for i = 1:length(X)

    del = del + (2*X(:,i)*(p14 + p1*X(:,i))*(c(1,i) - (p14 + p1*X(:,i))/(p34 + p3*X(:,i))))/(p34 + p3*X(:,i))^2 + (2*X(:,i)*(p24 + p2*X(:,i))*(c(2,i) - (p24 + p2*X(:,i))/(p34 + p3*X(:,i))))/(p34 + p3*X(:,i))^2;
end
   
    del = del + 2*lam1*p3' + lam2*( cross(repmat(p1',[1,3]),eye(3),1)*(cross(p2,p3))' + (cross(repmat(p2',[1,3]),eye(3),1))*(cross(p1,p3))');
end