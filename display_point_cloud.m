function display_point_cloud(X,c,img)

M = zeros(size(X,1),3);

R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);

M = [R(sub2ind(size(R),c(:,1),c(:,2))),G(sub2ind(size(G),c(:,1),c(:,2))),B(sub2ind(size(B),c(:,1),c(:,2))) ];

pcshow(X,M);

end