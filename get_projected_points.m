
function [X,laml,lamr] = get_projected_points(cl,cr,Pl,Pr)     %% assume I have six points here or points already selected or doesnt really matter

X = zeros(length(cl),3);
laml = zeros(length(cl),1);
lamr = zeros(length(cl),1);
p = [Pl(:,1:3);Pr(:,1:3)];
k = [-Pl(:,end);-Pr(:,end)];

for i = 1:length(cl)

m = [-cl(i,1) 0; -cl(i,2) 0; -1 0; 0 -cr(i,1); 0 -cr(i,2); 0 -1];
xn = pinv([p m]) * k;
X(i,:) = xn(1:3);
laml(i) = xn(4);
lamr(i) = xn(5);

end


             
end
