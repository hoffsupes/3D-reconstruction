function Fnew = eight_point_normalized(cl,cr)

Tl = [(sqrt(2)/mean(sqrt(sum((cl).^2,2)))),0,-mean(cl(:,1));0,(sqrt(2)/mean(sqrt(sum((cl).^2,2)))),-mean(cl(:,2));0,0,1];
Tr = [(sqrt(2)/mean(sqrt(sum((cr).^2,2)))),0,-mean(cr(:,1));0,(sqrt(2)/mean(sqrt(sum((cr).^2,2)))),-mean(cr(:,2));0,0,1];

cl = [cl ones(length(cl),1)]';
cr = [cr ones(length(cr),1)]';

cl = Tl*cl;
cl = cl ./ cl(3,:);
cl(3,:) = [];

cl = cl';

cr = Tr*cr;
cr = cr ./ cr(3,:);
cr(3,:) = [];

cr = cr';

CL = cl(:,1);
RL = cl(:,2);

CR = cr(:,1);
RR = cr(:,2);

A = [CL.*CR CL.*RR CL RL.*CR RL.*RR RL CR RR ones(length(CR),1) ];       

[~,~,S] = svd(A);                   %% take SVD
V = S(:,end);      

F(1,1) = V(1);
F(1,2) = V(2);
F(1,3) = V(3);
F(2,1) = V(4);
F(2,2) = V(5);
F(2,3) = V(6);
F(3,1) = V(7);
F(3,2) = V(8);
F(3,3) = V(9);

[S,D,V] = svd(F);

Dnew = D;
Dnew(Dnew == 0) = Inf;

[~,minD] = min(Dnew(:));
D(minD) = 0;

Fnew = S*D*V';

Fnew = Tl' * Fnew * Tr;



end