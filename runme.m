clc;
clear all;
close all;

load 2D.mat;
load 3D.mat;
load 3D_bad.mat;

c = c';
X = X';
Xbad = Xbad';

get_projection_linear(X,c)
get_projection_linear(Xbad,c)