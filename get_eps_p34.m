function del = get_eps_p34(X,c,p1,p2,p3,p14,p24,p34)

% XE = [p1 p14; p2 p24; p3 p34] * [X; ones(1,length(X))]; %% check, X c in c,r form
% 
% X1 = XE(1,:)./ XE(3,:);
% X2 = XE(2,:)./ XE(3,:);
% 
% X1a = X1 - c(1,:);
% X1b = (-X1 ./ XE(3,:)); %% check
% 
% X2a = X2 - c(2,:);
% X2b = (-X2 ./ XE(3,:)); %% check
% 
% del = sum(X1a.*X1b.*2 + X2a.*X2b.*2,2);
%%% del is a scalar

del = 0;

for i = 1:length(X)

    del = del + (2*(p14 + p1*X(:,i))*(c(1,i) - (p14 + p1*X(:,i))/(p34 + p3*X(:,i))))/(p34 + p3*X(:,i))^2 + (2*(p24 + p2*X(:,i))*(c(2,i) - (p24 + p2*X(:,i))/(p34 + p3*X(:,i))))/(p34 + p3*X(:,i))^2;
end
  
end