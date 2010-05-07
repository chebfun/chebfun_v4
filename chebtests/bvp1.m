function pass = bvp1

tol = chebfunpref('eps');

d = domain(-3,4);
D = diff(d);  I = eye(d);
A = D*D + 4*D + I;
A.lbc = -1;
A.rbc = 'neumann';
f = chebfun( 'exp(sin(x))',d );
u = A\f;

pass(1) = norm( diff(u,2) + 4*diff(u) + u - f ) < 1e-10*(tol/eps);
pass(2) = abs(u(d(1))+1)<1e-12*(tol/eps);
pass(3) = abs(feval(diff(u),d(2)))<1e-11*(tol/eps);



