
function [Xnew] = get_non_linear_points(M,cl,cr,thresh)     %% assume I have six points here or points already selected or doesnt really matter


for i = 1:size(M,1)
eps = 0;
step = 1000;

Xnew = zeros(size(M));

X = M(i,:);

delal = ones(size(X(1,:)))/step; 

epsnext = calc_error_X(X,cl,cr,ml1,ml2,ml3,mr1,mr2,mr3);
ii= 0;

while(abs(epsnext - eps) > thresh)

    delX = get_eps_X(X,cl,cr,ml1,ml2,ml3,mr1,mr2,mr3);
    
    X = X - delal.*delX';

    eps = epsnext;
    epsnext = calc_error_X(X,cl,cr,ml1,ml2,ml3,mr1,mr2,mr3);
    
ii = ii + 1;
end

Xnew(i,:) = X;

end

 end
