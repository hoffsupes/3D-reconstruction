function delX = get_eps_X(X,cl,cr,ml1,ml2,ml3,mr1,mr2,mr3)

delX = 2*(cl(1) - (ml1*X')/(ml3*X') )*((ml1*ml3'-ml1)/(ml3*X')^2) + 2*(cl(2) - (ml2*X')/(ml3*X') )*((ml2*ml3'-ml2)/(ml3*X')^2) + 2*(cr(1) - (mr1*X')/(mr3*X') )*((mr1*mr3'-mr1)/(mr3*X')^2) + 2*(cr(2) - (mr2*X')/(mr3*X') )*((mr2*mr3'-mr2)/(mr3*X')^2);

end