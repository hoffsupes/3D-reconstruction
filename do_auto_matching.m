function [matl,matr] = do_auto_matching(Lpts,Rpts,I1,I2)

[feat1,vp1] = extractFeatures(I1,Lpts);
[feat2,vp2] = extractFeatures(I2,Rpts);
ip = matchFeatures(feat1,feat2);

matl = vp1(ip(:,1),:);
matr = vp2(ip(:,2),:);

end