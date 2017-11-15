
function X = get_projected_points_2(cl,cr,Wl,Wr,R,T)     %% assume I have six points here or points already selected or doesnt really matter

X = zeros(length(cl),3);

N = length(cl);
k = Wr * R;
tw = Wr*T;
    
for j = 1:N

    A = [ (k(1,:) + k(2,:) - k(3,:)*cr(j,1)- k(3,:)*cr(j,2)),(tw(1)+tw(2)-cr(j,2)*tw(3)-cr(j,1)*tw(3)) ; (Wl(1,:) + Wl(2,:) -Wl(3,:)*cl(j,1)-Wl(3,:)*cl(j,2)), 0 ];
    [~,~,S] = svd(A);     
    V = S(:,end);
    V = V ./ V(4);
    V(4) = [];
    X(j,:) = V(:)'; 
end

             
end
