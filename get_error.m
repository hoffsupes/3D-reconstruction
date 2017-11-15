function get_error(P,X,c)

xx = P * [X'; ones(1,length(X))];
xx = xx./xx(3,:);
xx(3,:) = [];
mean(sqrt(sum((xx' - c).^2,2)))

end