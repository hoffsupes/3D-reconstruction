function Inew = get_btform_forward(Lzero,dmap,T,n,padr)

[~,~,chans] = size(Lzero);
[rm,cm,~] = size(dmap); 
Inew = zeros( ceil(n*size(Lzero,1)),ceil(n*size(Lzero,2)),1);
[R,Cl,~] = size(Inew);
[cz,rz] = meshgrid(1:Cl,1:R);

C = [cz(:) rz(:) ones(numel(cz),1)]';
Cnew = T*C;
Cnew = Cnew ./ Cnew(3,:);
Cnew(3,:) = [];
Cnew = Cnew + padr;

% Cnew(Cnew < 1) = 1;
% Cnew(1,(Cnew(1,:) > cm)) = cm;
% Cnew(2,(Cnew(2,:) > rm)) = rm;

Cf = floor(Cnew);
Cc = ceil(Cnew);

alpha = Cnew(1,:) - Cf(1,:);
beta =  Cnew(2,:) - Cf(2,:);

linp = ~((alpha == 0) & (beta == 0));

for j = 1:chans
    I = dmap(:,:,j);
for(i = 1:length(Cnew))

    if( (Cnew(2,i) >= 1 & Cnew(2,i) <= rm) & (Cnew(1,i) >= 1 & Cnew(1,i) <= cm) )
    if(linp(i) == 0)
        Inew(C(2,i),C(1,i),j) = I(Cnew(2,i),Cnew(1,i));
    else
        Inew(C(2,i),C(1,i),j) = (1-alpha(i))*(1-beta(i))*I(Cf(2,i),Cf(1,i)) + (1-beta(i))*(alpha(i))*I(Cf(2,i),Cc(1,i)) + (1-alpha(i))*(beta(i))*I(Cc(2,i),Cf(1,i)) + (alpha(i))*(beta(i))*I(Cc(2,i),Cc(1,i));
    end
    end
end
end

end