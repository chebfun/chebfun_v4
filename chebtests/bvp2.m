function pass = bvp2

tol = chebfunpref('eps');

d = domain(-1,0);
D = diff(d);  I = eye(d);
A = D*D + 4*D + 200;
A.lbc = {D+2,1};
A.rbc = D;
f = chebfun( 'x.*sin(3*x).^2',d );
u = A\f;
du = diff(u);

pass(1) = norm( diff(u,2) + 4*diff(u) + 200*u - f ) < 1e-10*(tol/eps);
pass(2) = abs(du(d(1))+2*u(d(1))-1)<1e-11*(tol/eps);
pass(3) = abs(feval(diff(u),d(2)))<1e-11*(tol/eps);



