
function [V,R] = get_el(F)     %% assume I have six points here or points already selected or doesnt really matter


[~,~,S] = svd(F');                   %% take SVD

V = S(:,end);                       %% last column of S
V = V ./ V(3);

[A,B] = eigs(F);
[~,ll] = min(max(abs(B)));
R = A(:,ll);
R = R ./ R(3);
end
