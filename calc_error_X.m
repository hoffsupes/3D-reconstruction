function E = calc_error_X(X,cl,cr,ml1,ml2,ml3,mr1,mr2,mr3)

E = (cl(1) - (ml1*X')/(ml3*X') )^2 + (cl(2) - (ml2*X')/(ml3*X') )^2 + (cr(1) - (mr1*X')/(mr3*X') )^2 + (cr(2) - (mr2*X')/(mr3*X') )^2;

end
