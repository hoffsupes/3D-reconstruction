clc;
clear all;
thresh = 0.5;
load('2D.mat');
load('3D.mat');

X = X';
c = c';

eps = 0;
% P = get_projection_linear(X,c);

Pbest =    1.0e+05 * [0.0126   -0.0112    0.0010   -5.6473;
0.0003    0.0009    0.0162   -5.9516;
0.0000    0.0000    0.0000   -0.0189;];

I = imread('frame1.bmp');

L = pinv(Pbest) * [c; ones(1,length(c))];
L = L ./ L(4,:);
L = L';
L(:,4) = [];

R = c(1,:) > 291;

imshow(I); hold on;
plot(c(1,R),c(2,R),'r+'); hold on;
hold on;