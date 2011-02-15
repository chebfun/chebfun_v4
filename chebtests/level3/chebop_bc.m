function pass = chebop_bc
% Solve two simple linear BVPs, check the solution vs. the exact
% solution and the precision of the boundary conditions.


tol = chebfunpref('eps');
deltol = cheboppref('deltol');
restol = cheboppref('restol');

d = domain(-3,4);
D = diff(d);  I = eye(d);
A = D*D + 4*D + I;
A.lbc = -1;
A.rbc = 'neumann';
f = chebfun( 'exp(sin(x))',d );
u = A\f;

pass(1) = norm( diff(u,2) + 4*diff(u) + u - f ) < deltol*u.scl*(tol/eps);
pass(2) = abs(u(d(1))+1) < restol*u.scl*(tol/eps);
pass(3) = abs(feval(diff(u),d(2))) < restol*u.scl*(tol/eps);


d = domain(-1,0);
D = diff(d);
A = D*D + 4*D + 200;
A.lbc = {D+2,1};
A.rbc = D;
f = chebfun( 'x.*sin(3*x).^2',d );
u = A\f;
du = diff(u);

pass(4) = norm( diff(u,2) + 4*diff(u) + 200*u - f ) < deltol*u.scl*(tol/eps);
pass(5) = abs(du(d(1))+2*u(d(1))-1) < restol*u.scl*(tol/eps);
pass(6) = abs(feval(diff(u),d(2))) < restol*u.scl*(tol/eps);



