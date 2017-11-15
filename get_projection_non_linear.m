
function P = get_projection_non_linear(X,c,thresh)     %% assume I have six points here or points already selected or doesnt really matter

clc;
clear all;
thresh = 0.5;
load('2D.mat');
load('3D.mat');

X = X';
c = c';

eps = 0;
P = eye(3,4);
lam1 = 0.01;
lam2 = 0.01;
step = 1000;

X = 

epsnext = calc_error(X,c,P,lam1,lam2)
ii= 0;
while(abs(epsnext - eps) > thresh)

    [delX] = get_eps_X(X,c,ml1,ml2,ml3,mr1,mr2,mr3);
    
    X = X - X.*delX;

    eps = epsnext;
    epsnext = calc_error(X,c,[p1 p14; p2 p24; p3 p34],lam1,lam2)
    eps;
ii = ii + 1;
ii
end

P = [p1 p14; p2 p24; p3 p34];
 end
