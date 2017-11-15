
function P = grad_NL(X,c,thresh)     %% assume I have six points here or points already selected or doesnt really matter

clc;
clear all;
thresh = 0.5;
load('2D.mat');
load('3D.mat');

X = X';
c = c';

eps = 0;
P = eye(3);
lam1 = 0.01;
lam2 = 0.01;
step = 1000;

p1 = P(1,1:end-1);    p14 = P(1,4);
p2 = P(2,1:end-1);    p24 = P(2,4);
p3 = P(3,1:end-1);    p34 = P(3,4);

p1al = ones(size(p1))/step; 
p2al = ones(size(p2))/step; 
p3al = ones(size(p3))/step; 

p14al = 1/step; 
p24al = 1/step; 
p34al = 1/step; 

epsnext = calc_error(X,c,P,lam1,lam2);

while(abs(epsnext - eps) > thresh)

    [del_p1,del_p2] = get_eps_p1_p2(X,c,p1,p2,p3,p14,p24,p34,lam2);
    del_p3 = get_eps_p3(X,c,p1,p2,p3,p14,p24,p34,lam1,lam2);
    [del_p14,del_p24] = get_eps_p14_p24(X,c,p1,p2,p3,p14,p24,p34);
    del_p34 = get_eps_p34(X,c,p1,p2,p3,p14,p24,p34);
    
    p1 = p1 - p1al.*del_p1';
    p2 = p2 - p2al.*del_p2';
    p3 = p3 - p3al.*del_p3';

    p14 = p14 - p14al.*del_p14;
    p24 = p24 - p24al.*del_p24;
    p34 = p34 - p34al.*del_p34;
    
    eps = epsnext;
    epsnext = calc_error(X,c,[p1 p14; p2 p24; p3 p34],lam1,lam2)
    eps;

end

P = [p1 p14; p2 p24; p3 p34]
end
 
function [del_p1,del_p2] = get_eps_p1_p2(X,c,p1,p2,p3,p14,p24,p34,lam2)


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

function eps = calc_error(X,c,P,lam1,lam2)

p1 = P(1,1:end-1);    p14 = P(1,4);
p2 = P(2,1:end-1);	p24 = P(2,4);
p3 = P(3,1:end-1);    p34 = P(3,4);

eps = 0;
for i = 1:length(X)
eps = eps + ( ((p1*X(:,i) + p14)/(p3*X(:,i)+p34)) - c(1,i))^2 + ( ((p2*X(:,i) + p24)/(p3*X(:,i)+p34)) - c(2,i))^2;

end
eps = eps + lam1*( norm(p3) - 1 ) + lam2*( cross(p1,p3) * cross(p2,p3)' );


end

function del = get_eps_p3(X,c,p1,p2,p3,p14,p24,p34,lam1,lam2)


del = 0;


for i = 1:length(X)

    del = del + (2*X(:,i)*(p14 + p1*X(:,i))*(c(1,i) - (p14 + p1*X(:,i))/(p34 + p3*X(:,i))))/(p34 + p3*X(:,i))^2 + (2*X(:,i)*(p24 + p2*X(:,i))*(c(2,i) - (p24 + p2*X(:,i))/(p34 + p3*X(:,i))))/(p34 + p3*X(:,i))^2;
end
   
    del = del + 2*lam1*p3' + lam2*( cross(repmat(p1',[1,3]),eye(3),1)*(cross(p2,p3))' + (cross(repmat(p2',[1,3]),eye(3),1))*(cross(p1,p3))');
end

function [del_p1,del_p2] = get_eps_p14_p24(X,c,p1,p2,p3,p14,p24,p34)


del_p1 = 0;
del_p2 = 0;

for i = 1:length(X)

    del_p1 = del_p1 + -(2*(c(1,i) - (p14 + p1*X(:,i))/(p34 + p3*X(:,i))))/(p34 + p3*X(:,i));
    del_p2 = del_p2 + -(2*(c(2,i) - (p24 + p2*X(:,i))/(p34 + p3*X(:,i))))/(p34 + p3*X(:,i));
    
end

end

function del = get_eps_p34(X,c,p1,p2,p3,p14,p24,p34)

del = 0;

for i = 1:length(X)

    del = del + (2*(p14 + p1*X(:,i))*(c(1,i) - (p14 + p1*X(:,i))/(p34 + p3*X(:,i))))/(p34 + p3*X(:,i))^2 + (2*(p24 + p2*X(:,i))*(c(2,i) - (p24 + p2*X(:,i))/(p34 + p3*X(:,i))))/(p34 + p3*X(:,i))^2;
end
  
end