function pass = ivp1
% This tests solves a linear IVP using chebop. It checks that the computed
% solution is accurate.


tol = chebfunpref('eps');

d = domain(-1,1);
x = chebfun(@(x) x,d);
I = eye(d);
D = diff(d);
A = (D-I) & {'dirichlet',exp(-1)-1};
u = A\(1-x);

pass = norm( u - (exp(x)+x) ) < 100*tol;
