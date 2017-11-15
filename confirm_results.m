clc;
clear all;
close all;
load 2D.mat;
load 3D.mat;
load 3D_bad.mat;

c = c';
X = X';
Xbad = Xbad';

P = get_projection_linear(X,c);     %% get best P
O = P * [Xbad; ones(1,length(Xbad))];   %% project Xbad
O = O ./ O(3,:);
O(3,:) = [];

outliers = find(sqrt(sum((O-c).^2)) > 3)        %% compare to c