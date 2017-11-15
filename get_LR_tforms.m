function [WL,WR] = get_LR_tforms(R,T,Wl,Wr,n)

Tn = T / norm(T);
rl1 = Tn';
rl2 = (1/( Tn(2)^2  + Tn(1)^2 )) * [Tn(2) -Tn(1) 0];
rl3 = cross(rl1,rl2);

Rl = [rl1;rl2;rl3];
Rr = Rl * R;

% Wl(1,1) = Wl(1,1) * n;
% Wl(2,2) = Wl(2,2) * n;

Wr(1,1) = Wr(1,1) * n;
Wr(2,2) = Wr(2,2) * n;

W = (1/2) * (Wl + Wr);

WL = W * Rl * inv(Wl);
WR = W * Rr * inv(Wr);

end