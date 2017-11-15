
function P = get_projection_linear(X,c)     %% assume I have six points here or points already selected or doesnt really matter

P = zeros(3,4);

X = X';
c = c';
N = length(X);
A = zeros(2*N,12);
i = 1;

for j = 1:N
    A(i,:)   = [X(j,:) 1 0 0 0 0 (-c(j,1)*X(j,:)) -c(j,1) ];            %% construct A
    A(i+1,:) = [0 0 0 0 X(j,:) 1 (-c(j,2)*X(j,:)) -c(j,2) ];
    i = i + 2;
end

[~,~,S] = svd(A);                   %% take SVD

V = S(:,end);                       %% last column of S
l = ( sqrt( (V(9))^2 + (V(10))^2 + (V(11))^2 ) );       %% 1/alpha

if l~=0
V = (1/l) * V;      %% V = alpha*V'
else
o = 100;
end

% 
% B = A(:,1:end-1);
% b = A(:,end);
% 
% Y = - inv((B'*B))*B'*b;
% p34 = 1 / ( sqrt( (Y(9))^2 + (Y(10))^2 + (Y(11))^2 ) );
% 
% V = p34*[Y;1]; 
% 
P(1,1) = V(1);
P(1,2) = V(2);
P(1,3) = V(3);
P(1,4) = V(4);

P(2,1) = V(5);
P(2,2) = V(6);
P(2,3) = V(7);
P(2,4) = V(8);

P(3,1) = V(9);
P(3,2) = V(10);
P(3,3) = V(11);
P(3,4) = V(12);         %% mapping V to P

end
