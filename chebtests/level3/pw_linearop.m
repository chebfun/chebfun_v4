function pass = pw_linop
% This test constructs a piecewise-linear chebop and checks 
% the accuracy of the solution for the ODEs:
% u'' + |x+.5|*u = |x| + |x-.5| + 2*sgn(x),
% u(-1) = 3, u(1) = 0.

% NH 08/2010

[d x] = domain(-1,1);
A = diff(d,2) + diag(abs(x+.5)) & {'dirichlet',[3 0]};
f = abs(x) + abs(x-.5) + 2*sign(x);
u = A\f;

% plot(f,'b',u,'--r')

err = A*u-f;
err = set(err,'imps',0*err.imps(1,:));
pass = norm(err,inf) < 2e-8;