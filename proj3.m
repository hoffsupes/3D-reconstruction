clc;
clear all;
close all;

load('2D_cal_left.mat')
load('2D_cal_right.mat')
load('3D_cal.mat')
load('img_pts.mat')

rsz = 1;        %% resizing factor, need not handle very larges always

cr = round(rsz*Cal_2D_right(:,2:3));
cl = round(rsz*Cal_2D_left(:,2:3));     %% for calibration in [c,r] form
c3  = Cal_3D(:,2:4);        %%  3D points for calibration

[Pr,inr,Rr,Tr,Wr] = do_RANSAC_refnew(c3',cr',0.99,6,0.7,3,0.85,0,1300*rsz); inr;
[Pl,inl,Rl,Tl,Wl] = do_RANSAC_refnew(c3',cl',0.99,6,0.7,3,0.85,0,1184*rsz); inl;        %% RANSAC to do outlier rejection in calibration

inv(Rr);
Rr';

inv(Rl);
Rl';

R = Rl*Rr';         %% relative rotation
T = Tl - R*Tr;      %% relative rotation

S = [0 -T(3) T(2); T(3) 0 -T(1); -T(2) T(1) 0];     %% get skew
F = inv(Wl)' * S'* R * inv(Wr);                     %% get F

Fnew = eight_point(cl,cr);                  %% F using eight point
Fnew = eight_point_normalized(cl,cr)        %% Normalized Eight Point Transform

LI = imread('/home/hulio/Downloads/project3_data/faceimage/left_face.jpg');
RI = imread('/home/hulio/Downloads/project3_data/faceimage/right_face.jpg');

rectLI = [682.5000  527.0000  207.0000  351.0000];  
rectRI = 1000*[1.3695    0.6020    0.2790    0.4740];

Lzero = imread('/home/hulio/Downloads/project3_data/faceimage/left_mask.jpg'); Lzero = 255*Lzero(:,:,1);
Rzero = imread('/home/hulio/Downloads/project3_data/faceimage/right_mask.jpg'); Rzero = 255*Rzero(:,:,1);

% 
% Lzero = zeros(size(LI,1),size(LI,2));
% Lzero(rectLI(2):rectLI(2)+rectLI(4),rectLI(1):rectLI(1)+rectLI(3)) = 255;
% 
% Rzero = zeros(size(LI,1),size(LI,2));
% Rzero(rectRI(2):rectRI(2)+rectRI(4),rectRI(1):rectRI(1)+rectRI(3)) = 255;

LI = imresize(LI,rsz);
RI = imresize(RI,rsz);

Lzero = imresize(Lzero,rsz);
Rzero = imresize(Rzero,rsz);

n = 1.556
padr = 10;
[WL,WR] = get_LR_tforms(R,T,Wl,Wr,1);           %% rectification transforms
imshowpair(uint8(get_btform(LI,WL,n)), uint8(get_btform(RI,WR,n)), 'montage'); figure;
imshowpair(LI, RI, 'montage');

rect_limg = WL*[limg ones(length(limg),1) ]'; rect_limg = round(rect_limg ./ rect_limg(3,:)); rect_limg(3,:) = []; rect_limg = rect_limg'; %% convert provided landmarks into rectified space
rect_rimg = WR*[rimg ones(length(rimg),1) ]'; rect_rimg = round(rect_rimg ./ rect_rimg(3,:)); rect_rimg(3,:) = []; rect_rimg = rect_rimg';

draw_lepline(limg,rimg,RI,F);   %% draw epipoles of points on left image ont right one
figure;
draw_repline(limg,rimg,LI,F);   %% draw epipoles of points on right image ont left one

rect_RI = uint8(get_btform(RI,WR,n));
rect_LI = uint8(get_btform(LI,WL,n));       %% rectified images

rect_RI = padarray(rect_RI,[padr padr]); rect_rimg = rect_rimg + padr;
rect_LI = padarray(rect_LI,[padr padr]); rect_limg = rect_limg + padr;      %% padding: note padding treated as a [pad,pad] transform
close all;
[dispty1,dispty2,matches,Lpts,bmap,dispr] = get_point_lists(LI,RI,Lzero,Rzero,rect_LI,rect_RI,WL,WR,n,padr,0,5,0.6,0.7);    %% actual matching
[dispty1auto,dispty2auto,matchesauto,Lptsauto,bmapauto,disprauto] = get_point_lists_auto(LI,RI,Lzero,Rzero,rect_LI,rect_RI,WL,WR,n,padr,0,5,0.8);
[zpk,zpk2] = get_original_pts(LI,Lpts,matches,padr,WL,WR,cl,cr,Pl,Pr);  %% convert matches to original space
[X,lam1,lam2] = get_projected_points(zpk,zpk2,Pl,Pr);       %% do triangulation
display_point_cloud(X,zpk,LI);              %% display point cloud
