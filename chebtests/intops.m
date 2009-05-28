function pass = intops

% Toby Driscoll 28 May 2009
% Check out integral operators

tol = chebfunpref('eps');
[d,x] = domain(0,1); 
F = fred(@(x,y) sin(2*pi*(x-y)),d);
A = eye(d)+F;
u = x.*exp(x);
f = A*u;
pass = norm(u-A\f) < 1e6*tol;


