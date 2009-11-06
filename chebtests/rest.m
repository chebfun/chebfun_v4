function pass = rest
tol = 100*chebfunpref('eps');

r = @(v) v(2:length(v));

f = chebfun('sech(x)',[0,inf]);
f2 = chebfun(chebpolyval(r(chebpoly(f))),[0,inf]);

f3 = f - f2

F = f3.*f3
I = sum(F.funs(1))

pass = ~isnan(I)

return

pass(1) = norm(f)-norm(f2) < tol;
pass(2) = norm(f3.vals) < tol;
pass(3) = norm(f3) < tol;
pass(4) = norm(f3,inf) < tol;


